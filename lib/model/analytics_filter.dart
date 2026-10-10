/// Immutable filters shared by the Sales Analytics screens.
///
/// This class deliberately contains only filter state. Analytics values and
/// business calculations continue to come from the existing backend APIs.
class AnalyticsFilter {
  static const String dailyPeriod = 'Daily';
  static const String weeklyPeriod = 'Weekly';
  static const String monthlyPeriod = 'Monthly';
  static const String yearlyPeriod = 'Yearly';
  static const String customRangePeriod = 'Custom Range';

  static const List<String> supportedPeriods = <String>[
    dailyPeriod,
    weeklyPeriod,
    monthlyPeriod,
    yearlyPeriod,
    customRangePeriod,
  ];

  static const Object _notProvided = Object();

  /// Month used by the commission dashboard.
  ///
  /// It is always normalised to the first day of the month.
  final DateTime month;

  /// Period understood by the existing `get_dashboard` API.
  final String period;

  /// Required only when [period] is [customRangePeriod].
  final DateTime? fromDate;
  final DateTime? toDate;

  /// Sales Person document name selected by a Sales Manager.
  ///
  /// A normal salesperson leaves this null and the backend resolves their own
  /// linked Sales Person. The backend remains the authority for access checks.
  final String? salesPerson;

  AnalyticsFilter({
    required DateTime month,
    this.period = monthlyPeriod,
    DateTime? fromDate,
    DateTime? toDate,
    String? salesPerson,
  })  : month = _dateOnly(DateTime(month.year, month.month, 1)),
        fromDate = fromDate == null ? null : _dateOnly(fromDate),
        toDate = toDate == null ? null : _dateOnly(toDate),
        salesPerson = _normaliseSalesPerson(salesPerson) {
    if (!supportedPeriods.contains(period)) {
      throw ArgumentError.value(
        period,
        'period',
        'Unsupported analytics period',
      );
    }

    if (period == customRangePeriod) {
      if (this.fromDate == null || this.toDate == null) {
        throw ArgumentError(
          'fromDate and toDate are required for Custom Range.',
        );
      }

      if (this.fromDate!.isAfter(this.toDate!)) {
        throw ArgumentError(
          'fromDate cannot be later than toDate.',
        );
      }
    }
  }

  factory AnalyticsFilter.initial({DateTime? now}) {
    final value = now ?? DateTime.now();

    return AnalyticsFilter(
      month: DateTime(value.year, value.month, 1),
    );
  }

  bool get isCustomRange => period == customRangePeriod;

  DateTime get monthStart => DateTime(month.year, month.month, 1);

  DateTime get monthEnd => DateTime(month.year, month.month + 1, 0);

  /// Effective range for screens backed by `get_dashboard`.
  DateTime get effectiveFromDate =>
      isCustomRange ? fromDate! : _periodStart(period, month);

  DateTime get effectiveToDate =>
      isCustomRange ? toDate! : _periodEnd(period, month);

  bool get hasSalesPerson =>
      salesPerson != null && salesPerson!.isNotEmpty;

  AnalyticsFilter copyWith({
    DateTime? month,
    String? period,
    Object? fromDate = _notProvided,
    Object? toDate = _notProvided,
    Object? salesPerson = _notProvided,
  }) {
    final nextPeriod = period ?? this.period;
    final nextFromDate = identical(fromDate, _notProvided)
        ? this.fromDate
        : fromDate as DateTime?;
    final nextToDate = identical(toDate, _notProvided)
        ? this.toDate
        : toDate as DateTime?;
    final nextSalesPerson = identical(salesPerson, _notProvided)
        ? this.salesPerson
        : salesPerson as String?;

    return AnalyticsFilter(
      month: month ?? this.month,
      period: nextPeriod,
      fromDate: nextPeriod == customRangePeriod ? nextFromDate : null,
      toDate: nextPeriod == customRangePeriod ? nextToDate : null,
      salesPerson: nextSalesPerson,
    );
  }

  AnalyticsFilter withMonth(DateTime value) {
    return copyWith(
      month: DateTime(value.year, value.month, 1),
    );
  }

  AnalyticsFilter withPeriod(String value) {
    return copyWith(period: value);
  }

  AnalyticsFilter withCustomRange({
    required DateTime from,
    required DateTime to,
  }) {
    return copyWith(
      period: customRangePeriod,
      fromDate: from,
      toDate: to,
    );
  }

  AnalyticsFilter withSalesPerson(String? value) {
    return copyWith(salesPerson: value);
  }

  AnalyticsFilter clearSalesPerson() {
    return copyWith(salesPerson: null);
  }

  /// Stable cache key for the existing commission endpoint.
  String get commissionCacheKey {
    return '${_formatDate(monthStart)}|${salesPerson ?? ''}';
  }

  /// Stable cache key for the existing general dashboard endpoint.
  String get dashboardCacheKey {
    return '$period|${_formatDate(effectiveFromDate)}|'
        '${_formatDate(effectiveToDate)}';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'month': _formatDate(monthStart),
      'period': period,
      if (isCustomRange) 'from_date': _formatDate(fromDate!),
      if (isCustomRange) 'to_date': _formatDate(toDate!),
      if (hasSalesPerson) 'sales_person': salesPerson,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnalyticsFilter &&
            _sameDate(other.month, month) &&
            other.period == period &&
            _sameNullableDate(other.fromDate, fromDate) &&
            _sameNullableDate(other.toDate, toDate) &&
            other.salesPerson == salesPerson;
  }

  @override
  int get hashCode => Object.hash(
        month.year,
        month.month,
        period,
        fromDate?.millisecondsSinceEpoch,
        toDate?.millisecondsSinceEpoch,
        salesPerson,
      );

  @override
  String toString() {
    return 'AnalyticsFilter(${toJson()})';
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static String? _normaliseSalesPerson(String? value) {
    final normalised = value?.trim();
    return normalised == null || normalised.isEmpty ? null : normalised;
  }

  static bool _sameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static bool _sameNullableDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return first == second;
    }
    return _sameDate(first, second);
  }

  static DateTime _periodStart(String period, DateTime anchor) {
    switch (period) {
      case dailyPeriod:
        return _dateOnly(anchor);
      case weeklyPeriod:
        return _dateOnly(
          anchor.subtract(Duration(days: anchor.weekday - 1)),
        );
      case yearlyPeriod:
        return DateTime(anchor.year, 1, 1);
      case monthlyPeriod:
      default:
        return DateTime(anchor.year, anchor.month, 1);
    }
  }

  static DateTime _periodEnd(String period, DateTime anchor) {
    switch (period) {
      case dailyPeriod:
        return _dateOnly(anchor);
      case weeklyPeriod:
        final start = _periodStart(weeklyPeriod, anchor);
        return start.add(const Duration(days: 6));
      case yearlyPeriod:
        return DateTime(anchor.year, 12, 31);
      case monthlyPeriod:
      default:
        return DateTime(anchor.year, anchor.month + 1, 0);
    }
  }

  static String _formatDate(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
