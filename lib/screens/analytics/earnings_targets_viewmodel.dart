import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import '../../../services/analytics_service.dart';

class EarningsTargetsViewModel extends BaseViewModel {
  EarningsTargetsViewModel({
    required AnalyticsFilter initialFilter,
    AnalyticsService? analyticsService,
  })  : _filter = initialFilter,
        _analyticsService = analyticsService ?? AnalyticsService();

  final AnalyticsService _analyticsService;

  AnalyticsFilter _filter;
  CommissionDashboard? _dashboard;
  String? _errorMessage;
  int _requestId = 0;

  AnalyticsFilter get filter => _filter;
  CommissionDashboard? get dashboard => _dashboard;
  CommissionSummary? get summary => _dashboard?.summary;
  String? get errorMessage => _errorMessage;

  bool get isInitialLoading => isBusy && _dashboard == null;
  bool get isRefreshing => isBusy && _dashboard != null;
  bool get hasData => _dashboard != null && _dashboard!.summary != null;
  bool get hasError => _errorMessage != null;
  bool get isSalesManager => _dashboard?.isSalesManager == true;

  List<CommissionSalesPerson> get salesPersons =>
      _dashboard?.salesPersons ?? const <CommissionSalesPerson>[];

  List<CommissionMilestone> get milestones =>
      _dashboard?.milestones ?? const <CommissionMilestone>[];

  List<CustomerCommissionOpportunity> get customerOpportunities =>
      _dashboard?.customerOpportunities ??
          const <CustomerCommissionOpportunity>[];

  CustomerOpportunitySummary get customerOpportunitySummary =>
      _dashboard?.customerOpportunitySummary ??
          const CustomerOpportunitySummary.empty();

  List<CommissionWeek> get weeks =>
      _dashboard?.weeks ?? const <CommissionWeek>[];

  CommissionNextGoal? get nextGoal => _dashboard?.nextGoal;
  String get currency => _dashboard?.currency ?? 'INR';

  String? get selectedSalesPerson =>
      _dashboard?.selectedSalesPerson?.name ?? _filter.salesPerson;

  String get selectedSalesPersonName =>
      _dashboard?.selectedSalesPerson?.displayName ?? 'Sales Person';

  String get personCaption {
    if (_dashboard == null) return 'Sales performance';
    if (isSalesManager) return 'Viewing $selectedSalesPersonName';

    final employeeName = _dashboard?.loggedInUser?.employeeName?.trim();
    return employeeName == null || employeeName.isEmpty
        ? 'Your sales performance'
        : employeeName;
  }

  String get monthLabel {
    final backendLabel = _dashboard?.period?.month.trim();
    if (backendLabel != null && backendLabel.isNotEmpty) {
      return backendLabel;
    }

    const months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_filter.month.month - 1]} ${_filter.month.year}';
  }

  bool get canMoveToNextMonth {
    final now = DateTime.now();
    return _filter.monthStart.isBefore(DateTime(now.year, now.month, 1));
  }

  String get customerEmptyTitle => isSalesManager
      ? 'No opportunities for $selectedSalesPersonName'
      : 'Unlock more customer commission';

  String get customerEmptyMessage => isSalesManager
      ? '$selectedSalesPersonName has not made a qualifying sale to a new '
      'or reactivated distributor during this month.'
      : 'Create a new distributor or reactivate an inactive distributor, '
      'complete the required sales and earn additional commission.';

  Future<void> initialise() async {
    if (_dashboard != null || isBusy) return;
    await _load(showError: false);
  }

  Future<void> refresh() => _load(forceRefresh: true, showError: false);

  Future<void> retry() => _load(forceRefresh: true, showError: true);

  Future<void> changeMonth(DateTime value) async {
    final month = DateTime(value.year, value.month, 1);
    if (_sameMonth(month, _filter.month)) return;
    _filter = _filter.withMonth(month);
    notifyListeners();
    await _load(forceRefresh: false, showError: true);
  }

  Future<void> previousMonth() {
    return changeMonth(
      DateTime(_filter.month.year, _filter.month.month - 1, 1),
    );
  }

  Future<void> nextMonth() async {
    if (!canMoveToNextMonth) return;
    await changeMonth(
      DateTime(_filter.month.year, _filter.month.month + 1, 1),
    );
  }

  Future<void> changeSalesPerson(String? value) async {
    if (!isSalesManager || isBusy) return;
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return;
    if (normalized == selectedSalesPerson) return;

    _filter = _filter.withSalesPerson(normalized);
    notifyListeners();
    await _load(forceRefresh: false, showError: true);
  }

  Future<void> _load({
    bool forceRefresh = false,
    bool showError = true,
  }) async {
    final currentRequest = ++_requestId;
    _errorMessage = null;
    setBusy(true);

    try {
      final result = await _analyticsService.loadEarningsAndTargets(
        filter: _filter,
        forceRefresh: forceRefresh,
        showError: showError,
      );

      if (currentRequest != _requestId) return;

      _dashboard = result;
      final selected = result.selectedSalesPerson?.name;
      if (selected != null && selected.trim().isNotEmpty) {
        _filter = _filter.withSalesPerson(selected);
      }

      final backendMonth = DateTime.tryParse(result.period?.monthValue ?? '');
      if (backendMonth != null) {
        _filter = _filter.withMonth(backendMonth);
      }
    } catch (error) {
      if (currentRequest != _requestId) return;
      _errorMessage = _friendlyError(error);
    } finally {
      if (currentRequest == _requestId) {
        setBusy(false);
      }
    }
  }

  String _friendlyError(Object error) {
    if (error is AnalyticsServiceException && error.message.isNotEmpty) {
      return error.message;
    }
    return 'Unable to load earnings and target details. Please try again.';
  }

  static bool _sameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;
}
