import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import '../../model/territory_summary_model.dart';
import '../../../services/analytics_service.dart';

class FieldPerformanceViewModel extends BaseViewModel {
  FieldPerformanceViewModel({
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

  int get visitTotal => _dashboard?.summary?.visit?.total ?? 0;
  int get tourTotal => _dashboard?.summary?.tours?.total ?? 0;
  int get fieldActivityTotal => visitTotal + tourTotal;

  List<SalesPerson> get dailyActivity {
    final rows = List<SalesPerson>.from(
      _dashboard?.salesPerson ?? const <SalesPerson>[],
    );
    rows.sort((first, second) {
      final firstDate = DateTime.tryParse(first.date ?? '');
      final secondDate = DateTime.tryParse(second.date ?? '');
      if (firstDate == null || secondDate == null) return 0;
      return firstDate.compareTo(secondDate);
    });
    return rows;
  }

  List<TerritorySummary> get activeTerritories {
    final rows = List<TerritorySummary>.from(
      _dashboard?.territory ?? const <TerritorySummary>[],
    );
    return rows
        .where(
          (row) =>
              _int(row.leads) > 0 ||
              _int(row.converted) > 0 ||
              _int(row.newCustomers) > 0,
        )
        .toList();
  }

  int get territoryLeadTotal => activeTerritories.fold<int>(
        0,
        (total, row) => total + _int(row.leads),
      );

  int get territoryConvertedTotal => activeTerritories.fold<int>(
        0,
        (total, row) => total + _int(row.converted),
      );

  int get territoryNewCustomerTotal => activeTerritories.fold<int>(
        0,
        (total, row) => total + _int(row.newCustomers),
      );

  bool get isCurrentMonth {
    final now = DateTime.now();
    return _filter.month.year == now.year && _filter.month.month == now.month;
  }

  bool get canMoveToNextMonth {
    final now = DateTime.now();
    return _filter.monthStart.isBefore(DateTime(now.year, now.month, 1));
  }

  String get monthLabel {
    const months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_filter.month.month - 1]} ${_filter.month.year}';
  }

  String get currentMonthLabel {
    final now = DateTime.now();
    const months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[now.month - 1]} ${now.year}';
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
      final result = await _analyticsService.loadFieldPerformance(
        filter: _filter,
        forceRefresh: forceRefresh,
      );

      if (currentRequest != _requestId) return;
      _dashboard = result;
    } catch (error) {
      if (currentRequest != _requestId) return;
      _errorMessage = error is AnalyticsServiceException
          ? error.message
          : 'Unable to load field performance. Please try again.';
    } finally {
      if (currentRequest == _requestId) setBusy(false);
    }
  }

  static int _int(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _sameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;
}
