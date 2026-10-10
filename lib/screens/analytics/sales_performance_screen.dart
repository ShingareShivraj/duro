import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/leaderboard_model.dart';
import '../../model/territory_summary_model.dart';
import 'sales_performance_viewmodel.dart';

class SalesPerformanceScreen extends StatefulWidget {
  final AnalyticsFilter initialFilter;

  const SalesPerformanceScreen({
    super.key,
    required this.initialFilter,
  });

  @override
  State<SalesPerformanceScreen> createState() =>
      _SalesPerformanceScreenState();
}

class _SalesPerformanceScreenState extends State<SalesPerformanceScreen> {
  static const Color _primary = Color(0xFF1769E0);
  static const Color _deepBlue = Color(0xFF0C3F9F);
  static const Color _green = Color(0xFF079669);
  static const Color _red = Color(0xFFDC4C4C);
  static const Color _orange = Color(0xFFF59E0B);
  static const Color _purple = Color(0xFF7257E8);
  static const Color _ink = Color(0xFF14213D);
  static const Color _muted = Color(0xFF667085);
  static const Color _border = Color(0xFFE5EAF2);
  static const Color _background = Color(0xFFF4F7FC);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesPerformanceViewModel>.reactive(
      viewModelBuilder: () => SalesPerformanceViewModel(
        initialFilter: widget.initialFilter,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _primary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            titleSpacing: 0,
            title: const Text(
              'Sales Performance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -.2,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: _buildBody(context, model),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context,
      SalesPerformanceViewModel model,
      ) {
    if (model.isInitialLoading) return const _LoadingState();

    if (!model.hasData) {
      return _ErrorState(
        message: model.errorMessage ?? 'Sales performance is unavailable.',
        onRetry: model.retry,
      );
    }

    return Stack(
      children: <Widget>[
        RefreshIndicator(
          color: _primary,
          onRefresh: model.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            children: <Widget>[
              _PeriodFilterBar(
                model: model,
                onPeriodSelected: (period) =>
                    _onPeriodSelected(context, model, period),
                onPeriodControlTap: () =>
                    _openActivePeriodPicker(context, model),
              ),
              if (model.isSalesManager) ...<Widget>[
                const SizedBox(height: 10),
                _SalesPersonSelector(model: model),
              ],
              if (model.hasError) ...<Widget>[
                const SizedBox(height: 9),
                _InlineError(
                  message: model.errorMessage!,
                  onRetry: model.retry,
                ),
              ],
              const SizedBox(height: 11),
              _PerformanceSummary(model: model),
              const SizedBox(height: 11),
              _SalesChartCard(model: model),
              const SizedBox(height: 11),
              _LeaderboardCard(model: model),
              const SizedBox(height: 11),
              _TerritoryCard(model: model),
            ],
          ),
        ),
        if (model.isRefreshing)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: _background.withOpacity(.56),
                alignment: Alignment.center,
                child: const _LoadingPill(),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onPeriodSelected(
      BuildContext context,
      SalesPerformanceViewModel model,
      String period,
      ) async {
    if (period == AnalyticsFilter.customRangePeriod) {
      await _selectCustomRange(context, model);
      return;
    }
    await model.changePeriod(period);
  }

  Future<void> _openActivePeriodPicker(
      BuildContext context,
      SalesPerformanceViewModel model,
      ) async {
    if (model.filter.isCustomRange) {
      await _selectCustomRange(context, model);
    } else if (model.filter.period == AnalyticsFilter.yearlyPeriod) {
      await _selectYear(context, model);
    } else {
      await _selectMonth(context, model);
    }
  }

  Future<void> _selectMonth(
      BuildContext context,
      SalesPerformanceViewModel model,
      ) async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPickerSheet(
        selectedMonth: model.filter.month,
      ),
    );
    if (!mounted || selected == null) return;
    await model.changeMonth(selected);
  }

  Future<void> _selectYear(
      BuildContext context,
      SalesPerformanceViewModel model,
      ) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _YearPickerSheet(
        selectedYear: model.filter.month.year,
      ),
    );
    if (!mounted || selected == null) return;
    await model.changeYear(selected);
  }

  Future<void> _selectCustomRange(
      BuildContext context,
      SalesPerformanceViewModel model,
      ) async {
    final now = DateTime.now();
    final initialStart = model.filter.isCustomRange
        ? model.filter.fromDate!
        : model.filter.monthStart;
    final initialEnd = model.filter.isCustomRange
        ? model.filter.toDate!
        : model.filter.monthEnd.isAfter(now)
        ? now
        : model.filter.monthEnd;

    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: initialStart.isAfter(now) ? now : initialStart,
        end: initialEnd,
      ),
      helpText: 'Select sales period',
      saveText: 'Apply',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || selected == null) return;
    await model.changeCustomRange(selected.start, selected.end);
  }
}

class _PeriodFilterBar extends StatelessWidget {
  final SalesPerformanceViewModel model;
  final ValueChanged<String> onPeriodSelected;
  final VoidCallback onPeriodControlTap;

  const _PeriodFilterBar({
    required this.model,
    required this.onPeriodSelected,
    required this.onPeriodControlTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _SalesPerformanceScreenState._border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0B102A56),
            blurRadius: 13,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: SalesPerformanceViewModel.availablePeriods.map((period) {
              final selected = model.filter.period == period;
              final label = period == AnalyticsFilter.customRangePeriod
                  ? 'Custom'
                  : period;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: selected
                        ? _SalesPerformanceScreenState._primary
                        : const Color(0xFFF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: model.isBusy
                          ? null
                          : () => onPeriodSelected(period),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : _SalesPerformanceScreenState._muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 9),
          Row(
            children: <Widget>[
              if (!model.filter.isCustomRange)
                _SmallArrow(
                  icon: Icons.chevron_left_rounded,
                  onTap: model.isBusy ? null : model.previousPeriod,
                ),
              Expanded(
                child: Material(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(11),
                  child: InkWell(
                    onTap: model.isBusy ? null : onPeriodControlTap,
                    borderRadius: BorderRadius.circular(11),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 17,
                            color: _SalesPerformanceScreenState._primary,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              model.periodLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _SalesPerformanceScreenState._deepBlue,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 17,
                            color: _SalesPerformanceScreenState._primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!model.filter.isCustomRange)
                _SmallArrow(
                  icon: Icons.chevron_right_rounded,
                  onTap: model.canMoveForward && !model.isBusy
                      ? model.nextPeriod
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SmallArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 38, height: 38),
      icon: Icon(
        icon,
        size: 21,
        color: onTap == null
            ? const Color(0xFFBBC3CF)
            : _SalesPerformanceScreenState._primary,
      ),
    );
  }
}

class _SalesPersonSelector extends StatelessWidget {
  final SalesPerformanceViewModel model;

  const _SalesPersonSelector({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _SalesPerformanceScreenState._border),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.manage_accounts_rounded,
              color: _SalesPerformanceScreenState._primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Salesperson',
                  style: TextStyle(
                    color: _SalesPerformanceScreenState._ink,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Focus individual performance',
                  style: TextStyle(
                    color: _SalesPerformanceScreenState._muted,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: model.selectedSalesPerson ?? '',
              borderRadius: BorderRadius.circular(14),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
              style: const TextStyle(
                color: _SalesPerformanceScreenState._ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              items: <DropdownMenuItem<String>>[
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('All Salespersons'),
                ),
                ...model.managerSalesPersons.map(
                      (name) => DropdownMenuItem<String>(
                    value: name,
                    child: SizedBox(
                      width: 120,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: model.isBusy ? null : model.changeSalesPerson,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceSummary extends StatelessWidget {
  final SalesPerformanceViewModel model;

  const _PerformanceSummary({required this.model});

  @override
  Widget build(BuildContext context) {
    final growth = model.growthPercentage;
    final growthColor = growth > 0
        ? _SalesPerformanceScreenState._green
        : growth < 0
        ? _SalesPerformanceScreenState._red
        : const Color(0xFF98A2B3);
    final growthIcon = growth > 0
        ? Icons.trending_up_rounded
        : growth < 0
        ? Icons.trending_down_rounded
        : Icons.trending_flat_rounded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _SalesPerformanceScreenState._border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0B102A56),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.focusedEntry == null
                          ? 'Team sales'
                          : model.focusedEntry!.salesPerson,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._muted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _money(model.totalSales),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._ink,
                        fontSize: 23,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: growthColor.withOpacity(.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(growthIcon, color: growthColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${growth.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: growthColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: <Widget>[
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.history_rounded,
                  label: model.previousPeriodLabel,
                  value: _compactMoney(model.previousSales),
                  color: _SalesPerformanceScreenState._purple,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.shopping_cart_checkout_rounded,
                  label: 'Orders',
                  value: '${model.totalOrders}',
                  color: _SalesPerformanceScreenState._orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.location_on_rounded,
                  label: 'Visits',
                  value: '${model.totalVisits}',
                  color: _SalesPerformanceScreenState._green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._ink,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._muted,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesChartCard extends StatelessWidget {
  final SalesPerformanceViewModel model;

  const _SalesChartCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Sales comparison',
      subtitle: 'Touch or drag across the chart to inspect a salesperson',
      icon: Icons.show_chart_rounded,
      trailing: _ChartLegend(
        currentLabel: model.currentPeriodLabel,
        previousLabel: model.previousPeriodLabel,
      ),
      child: model.chartEntries.isEmpty
          ? const _EmptyState(
        icon: Icons.show_chart_rounded,
        title: 'No sales data',
        message: 'No submitted sales are available for this period.',
      )
          : _InteractiveSalesChart(
        entries: model.chartEntries,
        highlightedSalesPerson: model.focusedEntry?.salesPerson,
        currentLabel: model.currentPeriodLabel,
        previousLabel: model.previousPeriodLabel,
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final String currentLabel;
  final String previousLabel;

  const _ChartLegend({
    required this.currentLabel,
    required this.previousLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _LegendDot(
          color: _SalesPerformanceScreenState._primary,
          label: currentLabel,
        ),
        const SizedBox(height: 3),
        _LegendDot(
          color: const Color(0xFF9AA9BE),
          label: previousLabel,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: _SalesPerformanceScreenState._muted,
            fontSize: 8.5,
          ),
        ),
      ],
    );
  }
}

class _InteractiveSalesChart extends StatefulWidget {
  final List<LeaderboardModel> entries;
  final String? highlightedSalesPerson;
  final String currentLabel;
  final String previousLabel;

  const _InteractiveSalesChart({
    required this.entries,
    required this.highlightedSalesPerson,
    required this.currentLabel,
    required this.previousLabel,
  });

  @override
  State<_InteractiveSalesChart> createState() =>
      _InteractiveSalesChartState();
}

class _InteractiveSalesChartState extends State<_InteractiveSalesChart> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _syncHighlightedEntry();
  }

  @override
  void didUpdateWidget(covariant _InteractiveSalesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlightedSalesPerson != widget.highlightedSalesPerson ||
        oldWidget.entries.length != widget.entries.length) {
      _syncHighlightedEntry();
    }
  }

  void _syncHighlightedEntry() {
    final target = widget.highlightedSalesPerson;
    if (target == null) {
      _selectedIndex = widget.entries.isEmpty ? null : 0;
      return;
    }
    final index = widget.entries.indexWhere(
          (entry) => entry.salesPerson == target,
    );
    _selectedIndex = index < 0 ? 0 : index;
  }

  void _selectFromPosition(double x, double width) {
    if (widget.entries.isEmpty) return;
    const left = 17.0;
    const right = 13.0;
    final plotWidth = math.max(1.0, width - left - right);
    final ratio = ((x - left) / plotWidth).clamp(0.0, 1.0).toDouble();
    final index = widget.entries.length == 1
        ? 0
        : (ratio * (widget.entries.length - 1)).round();
    if (index != _selectedIndex) setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const chartHeight = 220.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final index = (_selectedIndex ?? 0)
            .clamp(0, widget.entries.length - 1)
            .toInt();
        final selected = widget.entries[index];
        const tooltipWidth = 154.0;
        const left = 17.0;
        const right = 13.0;
        final plotWidth = math.max(1.0, width - left - right);
        final pointX = widget.entries.length == 1
            ? width / 2
            : left + (plotWidth * index / (widget.entries.length - 1));
        final tooltipLeft = (pointX - tooltipWidth / 2)
            .clamp(3.0, width - tooltipWidth - 3)
            .toDouble();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _selectFromPosition(details.localPosition.dx, width),
          onHorizontalDragUpdate: (details) =>
              _selectFromPosition(details.localPosition.dx, width),
          child: SizedBox(
            height: chartHeight,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SalesChartPainter(
                      entries: widget.entries,
                      selectedIndex: index,
                    ),
                  ),
                ),
                Positioned(
                  left: tooltipLeft,
                  top: 8,
                  width: tooltipWidth,
                  child: _ChartTooltip(
                    entry: selected,
                    currentLabel: widget.currentLabel,
                    previousLabel: widget.previousLabel,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  final List<LeaderboardModel> entries;
  final int selectedIndex;

  const _SalesChartPainter({
    required this.entries,
    required this.selectedIndex,
  });

  static double _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const left = 17.0;
    const right = 13.0;
    const top = 66.0;
    const bottom = 25.0;
    final plot = Rect.fromLTRB(left, top, size.width - right, size.height - bottom);

    final current = entries.map((entry) => _number(entry.totalSales)).toList();
    final previous = entries
        .map((entry) => _number(entry.comparison.previousSales))
        .toList();
    final highest = <double>[...current, ...previous].fold<double>(
      0,
          (value, item) => math.max(value, item),
    );
    final maximum = highest <= 0 ? 1.0 : highest * 1.15;

    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF4)
      ..strokeWidth = 1;
    for (int index = 0; index <= 4; index++) {
      final y = plot.top + plot.height * index / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    }

    Offset point(int index, double value) {
      final x = entries.length == 1
          ? plot.center.dx
          : plot.left + plot.width * index / (entries.length - 1);
      final y = plot.bottom - (value / maximum) * plot.height;
      return Offset(x, y);
    }

    final currentPoints = List<Offset>.generate(
      entries.length,
          (index) => point(index, current[index]),
    );
    final previousPoints = List<Offset>.generate(
      entries.length,
          (index) => point(index, previous[index]),
    );

    final fillPath = Path()
      ..moveTo(currentPoints.first.dx, plot.bottom)
      ..lineTo(currentPoints.first.dx, currentPoints.first.dy);
    for (int index = 1; index < currentPoints.length; index++) {
      fillPath.lineTo(currentPoints[index].dx, currentPoints[index].dy);
    }
    fillPath
      ..lineTo(currentPoints.last.dx, plot.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0x301769E0), Color(0x001769E0)],
        ).createShader(plot),
    );

    final previousPath = Path()
      ..moveTo(previousPoints.first.dx, previousPoints.first.dy);
    for (int index = 1; index < previousPoints.length; index++) {
      previousPath.lineTo(previousPoints[index].dx, previousPoints[index].dy);
    }
    _drawDashedPath(
      canvas,
      previousPath,
      Paint()
        ..color = const Color(0xFF9AA9BE)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke,
    );

    final currentPath = Path()
      ..moveTo(currentPoints.first.dx, currentPoints.first.dy);
    for (int index = 1; index < currentPoints.length; index++) {
      currentPath.lineTo(currentPoints[index].dx, currentPoints[index].dy);
    }
    canvas.drawPath(
      currentPath,
      Paint()
        ..color = _SalesPerformanceScreenState._primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final selectedPoint = currentPoints[selectedIndex];
    canvas.drawLine(
      Offset(selectedPoint.dx, plot.top),
      Offset(selectedPoint.dx, plot.bottom),
      Paint()
        ..color = const Color(0x661769E0)
        ..strokeWidth = 1.2,
    );

    for (int index = 0; index < currentPoints.length; index++) {
      final selected = index == selectedIndex;
      canvas.drawCircle(
        currentPoints[index],
        selected ? 5.5 : 3.2,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        currentPoints[index],
        selected ? 4.0 : 2.2,
        Paint()..color = _SalesPerformanceScreenState._primary,
      );
    }

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (int index = 0; index < entries.length; index++) {
      if (entries.length > 7 &&
          index != 0 &&
          index != selectedIndex &&
          index != entries.length - 1) {
        continue;
      }
      labelPainter.text = TextSpan(
        text: '#${entries[index].rank}',
        style: TextStyle(
          color: index == selectedIndex
              ? _SalesPerformanceScreenState._primary
              : _SalesPerformanceScreenState._muted,
          fontSize: 8.5,
          fontWeight: index == selectedIndex
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      );
      labelPainter.layout(maxWidth: 32);
      final x = currentPoints[index].dx - labelPainter.width / 2;
      labelPainter.paint(canvas, Offset(x, plot.bottom + 7));
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SalesChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.entries != entries;
  }
}

class _ChartTooltip extends StatelessWidget {
  final LeaderboardModel entry;
  final String currentLabel;
  final String previousLabel;

  const _ChartTooltip({
    required this.entry,
    required this.currentLabel,
    required this.previousLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _SalesPerformanceScreenState._ink,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x3214213D), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            entry.salesPerson,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: _TooltipValue(
                  label: currentLabel,
                  value: _compactMoney(_double(entry.totalSales)),
                  color: const Color(0xFF8DBBFF),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _TooltipValue(
                  label: previousLabel,
                  value: _compactMoney(
                    _double(entry.comparison.previousSales),
                  ),
                  color: const Color(0xFFC9D2E0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TooltipValue extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TooltipValue({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color.withOpacity(.78), fontSize: 7.5),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final SalesPerformanceViewModel model;

  const _LeaderboardCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Sales leaderboard',
      subtitle: '${model.fullLeaderboard.length} salespersons • '
          '${model.periodLabel}',
      icon: Icons.leaderboard_rounded,
      trailing: model.canExpandLeaderboard
          ? _ViewAllButton(
        expanded: model.showAllLeaderboard,
        onTap: model.toggleLeaderboardViewAll,
      )
          : null,
      child: model.fullLeaderboard.isEmpty
          ? const _EmptyState(
        icon: Icons.leaderboard_outlined,
        title: 'No leaderboard data',
        message: 'No submitted sales are available for this period.',
      )
          : Column(
        children: <Widget>[
          for (int index = 0;
          index < model.visibleLeaderboard.length;
          index++) ...<Widget>[
            _LeaderboardRow(
              entry: model.visibleLeaderboard[index],
              growth: model.cappedGrowthFor(
                model.visibleLeaderboard[index],
              ),
              maximumSales: _highestSales(model.fullLeaderboard),
              highlighted: model.focusedEntry?.salesPerson ==
                  model.visibleLeaderboard[index].salesPerson,
            ),
            if (index != model.visibleLeaderboard.length - 1)
              const Divider(height: 1, color: Color(0xFFEEF1F5)),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardModel entry;
  final double growth;
  final double maximumSales;
  final bool highlighted;

  const _LeaderboardRow({
    required this.entry,
    required this.growth,
    required this.maximumSales,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final sales = _double(entry.totalSales);
    final progress = maximumSales <= 0
        ? 0.0
        : (sales / maximumSales).clamp(0.0, 1.0).toDouble();
    final growthColor = growth > 0
        ? _SalesPerformanceScreenState._green
        : growth < 0
        ? _SalesPerformanceScreenState._red
        : const Color(0xFF98A2B3);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF3F7FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          _RankBadge(rank: entry.rank),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        entry.salesPerson,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _SalesPerformanceScreenState._ink,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _compactMoney(sales),
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._ink,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE7ECF4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      _SalesPerformanceScreenState._primary,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Text(
                      '${entry.orders} orders • ${entry.visits} visits',
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._muted,
                        fontSize: 8.8,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      growth > 0
                          ? Icons.arrow_upward_rounded
                          : growth < 0
                          ? Icons.arrow_downward_rounded
                          : Icons.remove_rounded,
                      color: growthColor,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${growth.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: growthColor,
                        fontSize: 8.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final color = rank == 1
        ? const Color(0xFFF2B21A)
        : rank == 2
        ? const Color(0xFF8C9AAA)
        : rank == 3
        ? const Color(0xFFB9784A)
        : _SalesPerformanceScreenState._primary;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(.11),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: rank <= 3
          ? Icon(Icons.workspace_premium_rounded, color: color, size: 19)
          : Text(
        '#$rank',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TerritoryCard extends StatelessWidget {
  final SalesPerformanceViewModel model;

  const _TerritoryCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Territory summary',
      subtitle: '${model.fullTerritories.length} territories • Company-wide',
      icon: Icons.map_rounded,
      trailing: model.canExpandTerritories
          ? _ViewAllButton(
        expanded: model.showAllTerritories,
        onTap: model.toggleTerritoryViewAll,
      )
          : null,
      child: model.fullTerritories.isEmpty
          ? const _EmptyState(
        icon: Icons.map_outlined,
        title: 'No territory data',
        message: 'Territory results are unavailable for this period.',
      )
          : Column(
        children: <Widget>[
          if (model.isSalesManager && model.selectedSalesPerson != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: _InfoNote(
                message:
                'Territories remain company-wide because the current API does not return salesperson-wise territory rows.',
              ),
            ),
          for (int index = 0;
          index < model.visibleTerritories.length;
          index++) ...<Widget>[
            _TerritoryRow(
              entry: model.visibleTerritories[index],
              conversion: model.territoryConversion(
                model.visibleTerritories[index],
              ),
            ),
            if (index != model.visibleTerritories.length - 1)
              const Divider(height: 1, color: Color(0xFFEEF1F5)),
          ],
        ],
      ),
    );
  }
}

class _TerritoryRow extends StatelessWidget {
  final TerritorySummary entry;
  final double conversion;

  const _TerritoryRow({
    required this.entry,
    required this.conversion,
  });

  @override
  Widget build(BuildContext context) {
    final leads = _integer(entry.leads);
    final converted = _integer(entry.converted);
    final newCustomers = _integer(entry.newCustomers);
    final hasData = leads > 0 || converted > 0 || newCustomers > 0;
    final color = hasData
        ? _SalesPerformanceScreenState._primary
        : const Color(0xFF98A2B3);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.location_on_rounded, color: color, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.territory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: hasData
                        ? _SalesPerformanceScreenState._ink
                        : _SalesPerformanceScreenState._muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: conversion / 100,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE7ECF4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hasData
                          ? _SalesPerformanceScreenState._green
                          : const Color(0xFFCBD2DC),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          _TerritoryMetric(label: 'Leads', value: '$leads'),
          _TerritoryMetric(label: 'New', value: '$newCustomers'),
          _TerritoryMetric(label: 'Converted', value: '$converted'),
          SizedBox(
            width: 38,
            child: Text(
              '${conversion.toStringAsFixed(0)}%',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: hasData
                    ? _SalesPerformanceScreenState._green
                    : _SalesPerformanceScreenState._muted,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerritoryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _TerritoryMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 43,
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._muted,
              fontSize: 7.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final Widget child;

  const _CardShell({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _SalesPerformanceScreenState._border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A102A56),
            blurRadius: 13,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _SalesPerformanceScreenState._primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _SalesPerformanceScreenState._muted,
                        fontSize: 9,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _ViewAllButton({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        minimumSize: const Size(0, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            expanded ? 'Show less' : 'View all',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.arrow_forward_ios_rounded,
            size: expanded ? 17 : 11,
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  final String message;

  const _InfoNote({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: _SalesPerformanceScreenState._orange,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF8A5A08),
                fontSize: 9,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.error_outline_rounded,
            color: _SalesPerformanceScreenState._red,
            size: 16,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF9F1C1C),
                fontSize: 10,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: const Color(0xFF98A2B3), size: 28),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._ink,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _SalesPerformanceScreenState._muted,
              fontSize: 9.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: <Widget>[
        _skeleton(102),
        const SizedBox(height: 11),
        _skeleton(145),
        const SizedBox(height: 11),
        _skeleton(285),
        const SizedBox(height: 11),
        _skeleton(220),
      ],
    );
  }

  Widget _skeleton(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
    );
  }
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x2214213D), blurRadius: 15),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 9),
          Text(
            'Updating insights…',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFF98A2B3),
              size: 42,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load analytics',
              style: TextStyle(
                color: _SalesPerformanceScreenState._ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _SalesPerformanceScreenState._muted,
                fontSize: 11,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthPickerSheet extends StatefulWidget {
  final DateTime selectedMonth;

  const _MonthPickerSheet({required this.selectedMonth});

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int _year;

  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.selectedMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        10,
        18,
        18 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD7DDE7),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Select month',
                  style: TextStyle(
                    color: _SalesPerformanceScreenState._ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _year--),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '$_year',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: _year < now.year
                    ? () => setState(() => _year++)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 7),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.25,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
            ),
            itemBuilder: (context, index) {
              final month = index + 1;
              final value = DateTime(_year, month, 1);
              final future = value.isAfter(DateTime(now.year, now.month, 1));
              final selected = widget.selectedMonth.year == _year &&
                  widget.selectedMonth.month == month;
              return Material(
                color: selected
                    ? _SalesPerformanceScreenState._primary
                    : const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: future
                      ? null
                      : () => Navigator.pop<DateTime>(context, value),
                  borderRadius: BorderRadius.circular(11),
                  child: Center(
                    child: Text(
                      _months[index],
                      style: TextStyle(
                        color: future
                            ? const Color(0xFFBCC4CF)
                            : selected
                            ? Colors.white
                            : _SalesPerformanceScreenState._ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _YearPickerSheet extends StatelessWidget {
  final int selectedYear;

  const _YearPickerSheet({required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final firstYear = currentYear - 10;
    final years = List<int>.generate(11, (index) => firstYear + index)
        .reversed
        .toList(growable: false);

    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        10,
        18,
        18 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD7DDE7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Select year',
            style: TextStyle(
              color: _SalesPerformanceScreenState._ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 13),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: years.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.25,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
            ),
            itemBuilder: (context, index) {
              final year = years[index];
              final selected = year == selectedYear;
              return Material(
                color: selected
                    ? _SalesPerformanceScreenState._primary
                    : const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: () => Navigator.pop<int>(context, year),
                  borderRadius: BorderRadius.circular(11),
                  child: Center(
                    child: Text(
                      '$year',
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : _SalesPerformanceScreenState._ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

double _highestSales(List<LeaderboardModel> entries) {
  return entries.fold<double>(
    0,
        (value, entry) => math.max(value, _double(entry.totalSales)),
  );
}

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _integer(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _money(double value) {
  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  ).format(value);
}

String _compactMoney(double value) {
  final absolute = value.abs();
  final sign = value < 0 ? '-' : '';
  if (absolute >= 10000000) {
    return '$sign₹${_trim(absolute / 10000000)}Cr';
  }
  if (absolute >= 100000) {
    return '$sign₹${_trim(absolute / 100000)}L';
  }
  if (absolute >= 1000) {
    return '$sign₹${_trim(absolute / 1000)}K';
  }
  return _money(value);
}

String _trim(double value) {
  final fixed = value.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}
