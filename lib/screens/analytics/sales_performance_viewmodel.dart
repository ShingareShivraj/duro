import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import '../../model/leaderboard_model.dart';
import '../../model/territory_summary_model.dart';
import '../../../services/analytics_service.dart';

class SalesPerformanceViewModel extends BaseViewModel {
  SalesPerformanceViewModel({
    required AnalyticsFilter initialFilter,
    AnalyticsService? analyticsService,
  })  : _filter = _normaliseInitialFilter(initialFilter),
        _analyticsService = analyticsService ?? AnalyticsService();

  static const int leaderboardPreviewCount = 3;
  static const int territoryPreviewCount = 4;

  static const List<String> availablePeriods = <String>[
    AnalyticsFilter.monthlyPeriod,
    AnalyticsFilter.yearlyPeriod,
    AnalyticsFilter.customRangePeriod,
  ];

  final AnalyticsService _analyticsService;

  AnalyticsFilter _filter;
  SalesPerformanceAnalyticsData? _data;
  String? _errorMessage;
  String? _selectedSalesPerson;
  bool _showAllLeaderboard = false;
  bool _showAllTerritories = false;
  int _requestId = 0;

  AnalyticsFilter get filter => _filter;
  SalesPerformanceAnalyticsData? get data => _data;
  DashBoard? get dashboard => _data?.dashboard;
  String? get errorMessage => _errorMessage;

  bool get isInitialLoading => isBusy && _data == null;
  bool get isRefreshing => isBusy && _data != null;
  bool get hasData => _data != null;
  bool get hasError => _errorMessage != null;
  bool get showAllLeaderboard => _showAllLeaderboard;
  bool get showAllTerritories => _showAllTerritories;

  String get currency => 'INR';

  bool get isSalesManager {
    final role = (dashboard?.role ?? '').trim().toLowerCase();
    return role == 'sales manager' || role.contains('sales manager');
  }

  List<LeaderboardModel> get fullLeaderboard {
    final rows = List<LeaderboardModel>.from(
      dashboard?.leaderboard ?? const <LeaderboardModel>[],
    );
    rows.sort((first, second) => first.rank.compareTo(second.rank));
    return rows;
  }

  List<LeaderboardModel> get visibleLeaderboard {
    final rows = fullLeaderboard;
    if (_showAllLeaderboard || rows.length <= leaderboardPreviewCount) {
      return rows;
    }
    return rows.take(leaderboardPreviewCount).toList(growable: false);
  }

  bool get canExpandLeaderboard =>
      fullLeaderboard.length > leaderboardPreviewCount;

  List<TerritorySummary> get fullTerritories {
    final rows = List<TerritorySummary>.from(
      dashboard?.territory ?? const <TerritorySummary>[],
    );

    rows.sort((first, second) {
      final firstHasData = _territoryHasData(first);
      final secondHasData = _territoryHasData(second);

      if (firstHasData != secondHasData) {
        return firstHasData ? -1 : 1;
      }

      final leadComparison =
      _asInt(second.leads).compareTo(_asInt(first.leads));
      if (leadComparison != 0) return leadComparison;

      return first.territory
          .toLowerCase()
          .compareTo(second.territory.toLowerCase());
    });

    return rows;
  }

  List<TerritorySummary> get visibleTerritories {
    final rows = fullTerritories;
    if (_showAllTerritories || rows.length <= territoryPreviewCount) {
      return rows;
    }
    return rows.take(territoryPreviewCount).toList(growable: false);
  }

  bool get canExpandTerritories =>
      fullTerritories.length > territoryPreviewCount;

  List<String> get managerSalesPersons => fullLeaderboard
      .map((entry) => entry.salesPerson.trim())
      .where((name) => name.isNotEmpty)
      .toSet()
      .toList(growable: false);

  String? get selectedSalesPerson => _selectedSalesPerson;

  String get selectedSalesPersonLabel =>
      _selectedSalesPerson ?? 'All Salespersons';

  LeaderboardModel? get focusedEntry {
    if (isSalesManager && _selectedSalesPerson != null) {
      return _findLeaderboardEntry(_selectedSalesPerson!);
    }

    if (!isSalesManager) {
      final employeeName = dashboard?.empName?.trim();
      if (employeeName != null && employeeName.isNotEmpty) {
        return _findLeaderboardEntry(employeeName);
      }
    }

    return null;
  }

  List<LeaderboardModel> get chartEntries => fullLeaderboard;

  double get totalSales {
    final focused = focusedEntry;
    if (focused != null) return _asDouble(focused.totalSales);
    return fullLeaderboard.fold<double>(
      0,
          (sum, entry) => sum + _asDouble(entry.totalSales),
    );
  }

  double get previousSales {
    final focused = focusedEntry;
    if (focused != null) {
      return _asDouble(focused.comparison.previousSales);
    }
    return fullLeaderboard.fold<double>(
      0,
          (sum, entry) =>
      sum + _asDouble(entry.comparison.previousSales),
    );
  }

  int get totalOrders {
    final focused = focusedEntry;
    if (focused != null) return _asInt(focused.orders);
    return fullLeaderboard.fold<int>(
      0,
          (sum, entry) => sum + _asInt(entry.orders),
    );
  }

  int get totalVisits {
    final focused = focusedEntry;
    if (focused != null) return _asInt(focused.visits);
    return fullLeaderboard.fold<int>(
      0,
          (sum, entry) => sum + _asInt(entry.visits),
    );
  }

  /// Product requirement: comparison displayed in the app must remain inside
  /// -100% to +100%, even if the backend/raw mathematical growth is higher.
  double get growthPercentage {
    if (previousSales <= 0) {
      return totalSales > 0 ? 100 : 0;
    }
    final growth = ((totalSales - previousSales) / previousSales) * 100;
    return growth.clamp(-100.0, 100.0).toDouble();
  }

  String get periodLabel {
    if (_filter.isCustomRange) {
      return '${_shortDate(_filter.fromDate!)} – '
          '${_shortDate(_filter.toDate!)}';
    }

    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      return '${_filter.month.year}';
    }

    return '${_monthName(_filter.month.month)} ${_filter.month.year}';
  }

  String get previousPeriodLabel {
    if (_filter.isCustomRange) return 'Previous range';
    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      return '${_filter.month.year - 1}';
    }
    final previous = DateTime(
      _filter.month.year,
      _filter.month.month - 1,
      1,
    );
    return '${_shortMonth(previous.month)} ${previous.year}';
  }

  String get currentPeriodLabel {
    if (_filter.isCustomRange) return 'Selected range';
    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      return '${_filter.month.year}';
    }
    return '${_shortMonth(_filter.month.month)} ${_filter.month.year}';
  }

  bool get canMoveForward {
    final now = DateTime.now();
    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      return _filter.month.year < now.year;
    }
    if (_filter.isCustomRange) return false;
    return _filter.monthStart.isBefore(DateTime(now.year, now.month, 1));
  }

  Future<void> initialise() async {
    if (_data != null || isBusy) return;
    await _load();
  }

  Future<void> refresh() => _load(forceRefresh: true);

  Future<void> retry() => _load(forceRefresh: true);

  Future<void> changePeriod(String period) async {
    if (!availablePeriods.contains(period) || period == _filter.period) return;

    if (period == AnalyticsFilter.customRangePeriod) return;

    _filter = _filter.withPeriod(period);
    _collapseLists();
    notifyListeners();
    await _load();
  }

  Future<void> changeMonth(DateTime month) async {
    final value = DateTime(month.year, month.month, 1);
    if (_sameMonth(value, _filter.month) &&
        _filter.period == AnalyticsFilter.monthlyPeriod) {
      return;
    }

    _filter = _filter
        .withMonth(value)
        .withPeriod(AnalyticsFilter.monthlyPeriod);
    _collapseLists();
    notifyListeners();
    await _load();
  }

  Future<void> changeYear(int year) async {
    if (year == _filter.month.year &&
        _filter.period == AnalyticsFilter.yearlyPeriod) {
      return;
    }

    _filter = _filter
        .withMonth(DateTime(year, 1, 1))
        .withPeriod(AnalyticsFilter.yearlyPeriod);
    _collapseLists();
    notifyListeners();
    await _load();
  }

  Future<void> changeCustomRange(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    if (start.isAfter(end)) return;

    _filter = _filter.withCustomRange(from: start, to: end);
    _collapseLists();
    notifyListeners();
    await _load();
  }

  Future<void> previousPeriod() async {
    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      await changeYear(_filter.month.year - 1);
      return;
    }
    if (_filter.period == AnalyticsFilter.monthlyPeriod) {
      await changeMonth(
        DateTime(_filter.month.year, _filter.month.month - 1, 1),
      );
    }
  }

  Future<void> nextPeriod() async {
    if (!canMoveForward) return;
    if (_filter.period == AnalyticsFilter.yearlyPeriod) {
      await changeYear(_filter.month.year + 1);
      return;
    }
    if (_filter.period == AnalyticsFilter.monthlyPeriod) {
      await changeMonth(
        DateTime(_filter.month.year, _filter.month.month + 1, 1),
      );
    }
  }

  void changeSalesPerson(String? value) {
    if (!isSalesManager) return;
    final normalized = value?.trim();
    _selectedSalesPerson =
    normalized == null || normalized.isEmpty ? null : normalized;
    notifyListeners();
  }

  void toggleLeaderboardViewAll() {
    _showAllLeaderboard = !_showAllLeaderboard;
    notifyListeners();
  }

  void toggleTerritoryViewAll() {
    _showAllTerritories = !_showAllTerritories;
    notifyListeners();
  }

  double cappedGrowthFor(LeaderboardModel entry) {
    return _asDouble(entry.comparison.percentage)
        .clamp(-100.0, 100.0)
        .toDouble();
  }

  double territoryConversion(TerritorySummary row) {
    final leads = _asInt(row.leads);
    if (leads <= 0) return 0;
    return ((_asInt(row.converted) / leads) * 100)
        .clamp(0.0, 100.0)
        .toDouble();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    final request = ++_requestId;
    _errorMessage = null;
    setBusy(true);

    try {
      final result = await _analyticsService.loadSalesPerformance(
        filter: _filter,
        forceRefresh: forceRefresh,
      );

      if (request != _requestId) return;
      _data = result;

      if (_selectedSalesPerson != null &&
          _findLeaderboardEntry(_selectedSalesPerson!) == null) {
        _selectedSalesPerson = null;
      }
    } catch (error) {
      if (request != _requestId) return;
      _errorMessage = _friendlyError(error);
    } finally {
      if (request == _requestId) setBusy(false);
    }
  }

  LeaderboardModel? _findLeaderboardEntry(String value) {
    final target = _normalise(value);
    for (final entry in fullLeaderboard) {
      final name = _normalise(entry.salesPerson);
      if (name == target || name.contains(target) || target.contains(name)) {
        return entry;
      }
    }
    return null;
  }

  void _collapseLists() {
    _showAllLeaderboard = false;
    _showAllTerritories = false;
  }

  String _friendlyError(Object error) {
    if (error is AnalyticsServiceException && error.message.isNotEmpty) {
      return error.message;
    }
    return 'Unable to load sales performance. Please try again.';
  }

  static AnalyticsFilter _normaliseInitialFilter(AnalyticsFilter filter) {
    if (filter.period == AnalyticsFilter.yearlyPeriod ||
        filter.period == AnalyticsFilter.customRangePeriod) {
      return filter;
    }
    return filter.withPeriod(AnalyticsFilter.monthlyPeriod);
  }

  static bool _territoryHasData(TerritorySummary row) {
    return _asInt(row.leads) > 0 ||
        _asInt(row.converted) > 0 ||
        _asInt(row.newCustomers) > 0;
  }

  static double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _asInt(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _normalise(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static bool _sameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }

  static String _shortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_shortMonth(date.month)} ${date.year}';
  }

  static String _monthName(int month) {
    const names = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }

  static String _shortMonth(int month) {
    const names = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }
}
