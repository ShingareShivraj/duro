import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';

/// Navigation choices exposed by the Analytics landing screen.
///
/// Keeping this as an enum prevents the UI from passing route names or magic
/// strings around. Detailed screens remain responsible for loading their own
/// data only after the user opens them.
enum AnalyticsDestination {
  earningsTargets,
  salesPerformance,
  fieldPerformance,
  workActivity,
}

class AnalyticsHomeViewModel extends BaseViewModel {
  AnalyticsHomeViewModel({AnalyticsFilter? initialFilter})
      : _filter = initialFilter ?? AnalyticsFilter.initial();

  AnalyticsFilter _filter;

  AnalyticsFilter get filter => _filter;

  DateTime get selectedMonth => _filter.monthStart;

  String get selectedMonthLabel {
    const months = <String>[
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

    return '${months[selectedMonth.month - 1]} ${selectedMonth.year}';
  }

  bool get canMoveToNextMonth {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    return selectedMonth.isBefore(currentMonth);
  }

  void selectMonth(DateTime month) {
    final value = DateTime(month.year, month.month, 1);
    if (_sameMonth(value, selectedMonth)) return;

    _filter = _filter.withMonth(value);
    notifyListeners();
  }

  void previousMonth() {
    selectMonth(DateTime(selectedMonth.year, selectedMonth.month - 1, 1));
  }

  void nextMonth() {
    if (!canMoveToNextMonth) return;
    selectMonth(DateTime(selectedMonth.year, selectedMonth.month + 1, 1));
  }

  void resetToCurrentMonth() {
    final now = DateTime.now();
    selectMonth(DateTime(now.year, now.month, 1));
  }

  static bool _sameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }
}
