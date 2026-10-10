import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import '../../services/analytics_service.dart';

class WorkActivityViewModel extends BaseViewModel {
  WorkActivityViewModel({
    required AnalyticsFilter initialFilter,
    AnalyticsService? analyticsService,
  })  : _filter = initialFilter,
        _analyticsService = analyticsService ?? AnalyticsService();

  final AnalyticsService _analyticsService;

  AnalyticsFilter _filter;
  DashBoard? _dashboard;
  String? _errorMessage;
  int _requestId = 0;

  AnalyticsFilter get filter => _filter;
  DashBoard? get dashboard => _dashboard;
  String? get errorMessage => _errorMessage;

  bool get isInitialLoading => isBusy && _dashboard == null;
  bool get isRefreshing => isBusy && _dashboard != null;
  bool get hasData => _dashboard != null;
  bool get hasError => _errorMessage != null;

  int get visits => _dashboard?.summary?.visit?.total ?? 0;
  int get attendance => _dashboard?.summary?.attendance?.total ?? 0;
  int get leaves => _dashboard?.summary?.leave?.total ?? 0;
  int get orders => _dashboard?.summary?.orders?.total ?? 0;
  int get leads => _dashboard?.summary?.leads?.total ?? 0;
  int get tours => _dashboard?.summary?.tours?.total ?? 0;

  /// Count of business actions, excluding attendance and leave records.
  int get workActions => visits + tours + orders + leads;

  bool get hasAnyActivity =>
      workActions > 0 || attendance > 0 || leaves > 0;

  String get employeeName {
    final name = _dashboard?.empName?.trim();
    return name == null || name.isEmpty ? 'My activity' : name;
  }

  String get companyName {
    final company = _dashboard?.company?.trim();
    return company == null || company.isEmpty ? 'Company workspace' : company;
  }

  String get monthLabel {
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

  Future<void> initialise() async {
    if (_dashboard != null || isBusy) return;
    await _load();
  }

  Future<void> refresh() => _load(forceRefresh: true);

  Future<void> retry() => _load(forceRefresh: true);

  Future<void> changeMonth(DateTime value) async {
    final normalized = DateTime(value.year, value.month, 1);
    if (_sameMonth(normalized, _filter.month)) return;

    _filter = _filter.withMonth(normalized);
    notifyListeners();
    await _load();
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

  Future<void> _load({bool forceRefresh = false}) async {
    final currentRequest = ++_requestId;
    _errorMessage = null;
    setBusy(true);

    try {
      final result = await _analyticsService.loadWorkActivity(
        filter: _filter,
        forceRefresh: forceRefresh,
      );

      if (currentRequest != _requestId) return;
      _dashboard = result;
    } catch (error) {
      if (currentRequest != _requestId) return;
      _errorMessage = error is AnalyticsServiceException
          ? error.message
          : 'Unable to load work activity. Please try again.';
    } finally {
      if (currentRequest == _requestId) setBusy(false);
    }
  }

  static bool _sameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;
}
