import 'package:flutter/material.dart';

import '../model/analytics_filter.dart';
import '../model/dashboard.dart';
import 'home_services.dart';

/// Read-only, lazy-loading facade for the Sales Analytics feature.
///
/// It reuses the currently working Home APIs and models. No commission or
/// performance calculation is duplicated in Flutter.
class AnalyticsService {
  AnalyticsService({HomeServices? homeServices})
      : _homeServices = homeServices ?? HomeServices();

  final HomeServices _homeServices;

  final Map<String, CommissionDashboard> _commissionCache =
      <String, CommissionDashboard>{};
  final Map<String, DashBoard> _dashboardCache = <String, DashBoard>{};

  /// Loads monthly earnings, targets, customer opportunities, commission
  /// milestones and weekly commission data.
  ///
  /// For a Sales Manager, [AnalyticsFilter.salesPerson] is forwarded to the
  /// backend. For a normal salesperson it remains null, allowing the backend
  /// to enforce and resolve the logged-in employee's Sales Person.
  Future<CommissionDashboard> loadEarningsAndTargets({
    required AnalyticsFilter filter,
    bool forceRefresh = false,
    bool showError = true,
  }) async {
    return _loadCommissionDashboard(
      filter: filter,
      forceRefresh: forceRefresh,
      showError: showError,
    );
  }

  /// Loads the data required by Sales Performance.
  ///
  /// - [commission] supplies the existing weekly sales/commission rows.
  /// - [dashboard] supplies the existing team leaderboard.
  ///
  /// The current general dashboard endpoint does not accept a Sales Person
  /// filter, so the leaderboard keeps its current backend/company semantics.
  Future<SalesPerformanceAnalyticsData> loadSalesPerformance({
    required AnalyticsFilter filter,
    bool forceRefresh = false,
    bool showError = true,
  }) async {
    final results = await Future.wait<dynamic>(<Future<dynamic>>[
      _loadCommissionDashboard(
        filter: filter,
        forceRefresh: forceRefresh,
        showError: showError,
      ),
      _loadDashboardAnalytics(
        filter: filter,
        forceRefresh: forceRefresh,
      ),
    ]);

    return SalesPerformanceAnalyticsData(
      commission: results[0] as CommissionDashboard,
      dashboard: results[1] as DashBoard,
    );
  }

  /// Loads visit, tour and territory analytics from the existing dashboard
  /// endpoint only when Field Performance is opened.
  Future<DashBoard> loadFieldPerformance({
    required AnalyticsFilter filter,
    bool forceRefresh = false,
  }) {
    return _loadDashboardAnalytics(
      filter: filter,
      forceRefresh: forceRefresh,
    );
  }

  /// Loads visits, attendance, leaves, orders, leads and tours totals from the
  /// existing dashboard endpoint only when Work Activity is opened.
  Future<DashBoard> loadWorkActivity({
    required AnalyticsFilter filter,
    bool forceRefresh = false,
  }) {
    return _loadDashboardAnalytics(
      filter: filter,
      forceRefresh: forceRefresh,
    );
  }

  /// Public shared loader for screens that need the existing dashboard
  /// analytics response directly.
  Future<DashBoard> loadDashboardAnalytics({
    required AnalyticsFilter filter,
    bool forceRefresh = false,
  }) {
    return _loadDashboardAnalytics(
      filter: filter,
      forceRefresh: forceRefresh,
    );
  }

  Future<CommissionDashboard> _loadCommissionDashboard({
    required AnalyticsFilter filter,
    required bool forceRefresh,
    required bool showError,
  }) async {
    final cacheKey = filter.commissionCacheKey;

    if (!forceRefresh) {
      final cached = _commissionCache[cacheKey];
      if (cached != null) {
        return cached;
      }
    }

    final result = await _homeServices.commissionDashboard(
      month: filter.monthStart,
      salesPerson: filter.salesPerson,
      showError: showError,
    );

    if (result == null) {
      throw const AnalyticsServiceException(
        'Unable to load earnings and commission details.',
      );
    }

    _commissionCache[cacheKey] = result;
    return result;
  }

  Future<DashBoard> _loadDashboardAnalytics({
    required AnalyticsFilter filter,
    required bool forceRefresh,
  }) async {
    final cacheKey = filter.dashboardCacheKey;

    if (!forceRefresh) {
      final cached = _dashboardCache[cacheKey];
      if (cached != null) {
        return cached;
      }
    }

    // `get_dashboard` reads from_date/to_date only for "Custom Range".
    // Send the selected month as an exact range so its data stays aligned
    // with the month used by the commission endpoint.
    final useExactRange =
        filter.isCustomRange || filter.period == AnalyticsFilter.monthlyPeriod;

    final range = useExactRange
        ? DateTimeRange(
            start: filter.isCustomRange
                ? filter.fromDate!
                : filter.monthStart,
            end: filter.isCustomRange
                ? filter.toDate!
                : filter.monthEnd,
          )
        : null;

    final requestPeriod = useExactRange
        ? AnalyticsFilter.customRangePeriod
        : filter.period;

    final result = await _homeServices.dashboard(
      requestPeriod,
      range: range,
    );

    if (result == null) {
      throw const AnalyticsServiceException(
        'Unable to load analytics details.',
      );
    }

    _dashboardCache[cacheKey] = result;
    return result;
  }

  /// Removes cached values for a particular filter after a manual refresh or
  /// when a caller knows that related ERPNext data has changed.
  void invalidate(AnalyticsFilter filter) {
    _commissionCache.remove(filter.commissionCacheKey);
    _dashboardCache.remove(filter.dashboardCacheKey);
  }

  /// Clears all in-memory analytics data, for example during logout.
  void clearCache() {
    _commissionCache.clear();
    _dashboardCache.clear();
  }
}

/// Combined result required by the Sales Performance screen.
class SalesPerformanceAnalyticsData {
  final CommissionDashboard commission;
  final DashBoard dashboard;

  const SalesPerformanceAnalyticsData({
    required this.commission,
    required this.dashboard,
  });
}

class AnalyticsServiceException implements Exception {
  final String message;

  const AnalyticsServiceException(this.message);

  @override
  String toString() => message;
}
