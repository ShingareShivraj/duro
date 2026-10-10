import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import '../../model/territory_summary_model.dart';
import 'field_performance_viewmodel.dart';

class FieldPerformanceScreen extends StatefulWidget {
  final AnalyticsFilter initialFilter;

  const FieldPerformanceScreen({
    super.key,
    required this.initialFilter,
  });

  @override
  State<FieldPerformanceScreen> createState() =>
      _FieldPerformanceScreenState();
}

class _FieldPerformanceScreenState extends State<FieldPerformanceScreen>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF1769E0);
  static const _deepBlue = Color(0xFF0F4FB7);
  static const _green = Color(0xFF079669);
  static const _purple = Color(0xFF7A4DE8);
  static const _orange = Color(0xFFF59E0B);
  static const _red = Color(0xFFDC4C4C);
  static const _ink = Color(0xFF14213D);
  static const _muted = Color(0xFF667085);
  static const _border = Color(0xFFE5EAF2);
  static const _background = Color(0xFFF4F7FC);

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FieldPerformanceViewModel>.reactive(
      viewModelBuilder: () => FieldPerformanceViewModel(
        initialFilter: widget.initialFilter,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _background,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: _ink),
            ),
            titleSpacing: 0,
            title: const Text(
              'Field Performance',
              style: TextStyle(
                color: _ink,
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -.25,
              ),
            ),
          ),
          body: SafeArea(top: false, child: _body(model)),
        );
      },
    );
  }

  Widget _body(FieldPerformanceViewModel model) {
    if (model.isInitialLoading) return const _LoadingState();

    if (!model.hasData) {
      return _ErrorState(
        message: model.errorMessage ?? 'Field performance is unavailable.',
        onRetry: model.retry,
      );
    }

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
              child: Column(
                children: <Widget>[
                  _FieldHeader(model: model),
                  if (model.hasError) ...<Widget>[
                    const SizedBox(height: 8),
                    _InlineError(message: model.errorMessage!, onRetry: model.retry),
                  ],
                  const SizedBox(height: 12),
                  _FieldTabs(
                    controller: _tabController,
                    territoryCount: model.activeTerritories.length,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _ActivityTab(model: model),
                  _TerritoryTab(model: model),
                ],
              ),
            ),
          ],
        ),
        if (model.isRefreshing)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: _background.withOpacity(.58),
                alignment: Alignment.center,
                child: const _LoadingPill(),
              ),
            ),
          ),
      ],
    );
  }
}

class _FieldHeader extends StatelessWidget {
  final FieldPerformanceViewModel model;

  const _FieldHeader({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            _FieldPerformanceScreenState._deepBlue,
            _FieldPerformanceScreenState._primary,
            Color(0xFF3F8EF4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x251769E0), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.route_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Field Activity',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      model.monthLabel,
                      style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              _MonthControl(model: model),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _HeroStat(
                  icon: Icons.pin_drop_rounded,
                  label: 'Visits',
                  value: '${model.visitTotal}',
                  accent: const Color(0xFFBDE0FF),
                ),
              ),
              _divider(),
              Expanded(
                child: _HeroStat(
                  icon: Icons.directions_car_filled_rounded,
                  label: 'Tours',
                  value: '${model.tourTotal}',
                  accent: const Color(0xFFC7F0DE),
                ),
              ),
              _divider(),
              Expanded(
                child: _HeroStat(
                  icon: Icons.task_alt_rounded,
                  label: 'Activities',
                  value: '${model.fieldActivityTotal}',
                  accent: const Color(0xFFFFE0A8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _divider() => Container(
        width: 1,
        height: 43,
        color: Colors.white.withOpacity(.20),
      );
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _HeroStat({required this.icon, required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: accent, size: 15),
            const SizedBox(width: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(.67), fontSize: 9.5)),
      ],
    );
  }
}

class _MonthControl extends StatelessWidget {
  final FieldPerformanceViewModel model;

  const _MonthControl({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _arrow(Icons.chevron_left_rounded, model.previousMonth),
          InkWell(
            onTap: () => _pickMonth(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: 17),
            ),
          ),
          _arrow(Icons.chevron_right_rounded, model.canMoveToNextMonth ? model.nextMonth : null),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback? action) {
    return IconButton(
      onPressed: action,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 31, height: 34),
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 19, color: action == null ? Colors.white.withOpacity(.3) : Colors.white),
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final value = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPicker(selected: model.filter.month),
    );
    if (value != null) await model.changeMonth(value);
  }
}

class _FieldTabs extends StatelessWidget {
  final TabController controller;
  final int territoryCount;

  const _FieldTabs({required this.controller, required this.territoryCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFE9EEF6), borderRadius: BorderRadius.circular(14)),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x10112244), blurRadius: 7, offset: Offset(0, 2))],
        ),
        labelColor: _FieldPerformanceScreenState._primary,
        unselectedLabelColor: _FieldPerformanceScreenState._muted,
        labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
        tabs: <Widget>[
          const Tab(text: 'Visits & Tours'),
          Tab(text: territoryCount > 0 ? 'Territories ($territoryCount)' : 'Territories'),
        ],
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final FieldPerformanceViewModel model;

  const _ActivityTab({required this.model});

  @override
  Widget build(BuildContext context) {
    final activity = model.dailyActivity;

    return RefreshIndicator(
      onRefresh: model.refresh,
      color: _FieldPerformanceScreenState._primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
        children: <Widget>[
          _SectionCard(
            title: 'Visit & tour activity',
            subtitle: model.isCurrentMonth
                ? model.currentMonthLabel
                : 'Daily chart available for ${model.currentMonthLabel}',
            icon: Icons.stacked_bar_chart_rounded,
            child: !model.isCurrentMonth
                ? _HistoricalActivityNotice(selectedMonth: model.monthLabel)
                : activity.isEmpty
                    ? const _SimpleEmpty(
                        icon: Icons.route_outlined,
                        title: 'No field activity',
                        message: 'No visit or tour entries are available for the current month.',
                      )
                    : _ActivityChart(rows: activity),
          ),
          const SizedBox(height: 11),
          _SectionTitle(title: 'Selected month summary'),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _SummaryCard(
                  icon: Icons.pin_drop_rounded,
                  label: 'Visits completed',
                  value: '${model.visitTotal}',
                  color: _FieldPerformanceScreenState._primary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.directions_car_filled_rounded,
                  label: 'Tours completed',
                  value: '${model.tourTotal}',
                  color: _FieldPerformanceScreenState._green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _InfoBanner(
            icon: Icons.verified_user_outlined,
            message: 'Counts are read directly from submitted Visit and Tours records for the selected period.',
            color: _FieldPerformanceScreenState._primary,
          ),
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  final List<SalesPerson> rows;

  const _ActivityChart({required this.rows});

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.length <= 14 ? rows : rows.sublist(rows.length - 14);
    int maximum = 0;
    for (final row in visibleRows) {
      final value = (row.visitCount ?? 0) + (row.tourCount ?? 0);
      if (value > maximum) maximum = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            _LegendDot(color: _FieldPerformanceScreenState._primary, label: 'Visits'),
            SizedBox(width: 15),
            _LegendDot(color: _FieldPerformanceScreenState._green, label: 'Tours'),
            Spacer(),
            Text('Last 14 entries', style: TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 9)),
          ],
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 190,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: visibleRows.map((row) {
                final visits = row.visitCount ?? 0;
                final tours = row.tourCount ?? 0;
                return _ActivityBarGroup(
                  date: row.date,
                  visits: visits,
                  tours: tours,
                  maximum: maximum,
                );
              }).toList(),
            ),
          ),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 9.5, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ActivityBarGroup extends StatelessWidget {
  final String? date;
  final int visits;
  final int tours;
  final int maximum;

  const _ActivityBarGroup({required this.date, required this.visits, required this.tours, required this.maximum});

  @override
  Widget build(BuildContext context) {
    final visitRatio = maximum <= 0 ? 0.0 : (visits / maximum).clamp(0.0, 1.0).toDouble();
    final tourRatio = maximum <= 0 ? 0.0 : (tours / maximum).clamp(0.0, 1.0).toDouble();

    return SizedBox(
      width: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '${visits + tours}',
            style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 8.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _bar(visitRatio, _FieldPerformanceScreenState._primary),
                const SizedBox(width: 3),
                _bar(tourRatio, _FieldPerformanceScreenState._green),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(_dayLabel(date), style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 8.5)),
        ],
      ),
    );
  }

  Widget _bar(double ratio, Color color) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final height = maximum <= 0
            ? 5.0
            : (constraints.maxHeight * ratio).clamp(6.0, constraints.maxHeight).toDouble();
        return Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 420),
            height: height,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ),
        );
      },
    );
  }
}

class _HistoricalActivityNotice extends StatelessWidget {
  final String selectedMonth;

  const _HistoricalActivityNotice({required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFFFF8E7), borderRadius: BorderRadius.circular(13)),
      child: Column(
        children: <Widget>[
          const Icon(Icons.history_rounded, color: _FieldPerformanceScreenState._orange, size: 26),
          const SizedBox(height: 7),
          Text(
            'Daily chart unavailable for $selectedMonth',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'The current API returns daily visit and tour rows for the current month only. The totals below still follow your selected month.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 10, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _TerritoryTab extends StatelessWidget {
  final FieldPerformanceViewModel model;

  const _TerritoryTab({required this.model});

  @override
  Widget build(BuildContext context) {
    final entries = model.activeTerritories;

    return RefreshIndicator(
      onRefresh: model.refresh,
      color: _FieldPerformanceScreenState._primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _TinyMetric(label: 'Leads', value: '${model.territoryLeadTotal}', color: _FieldPerformanceScreenState._purple)),
              const SizedBox(width: 8),
              Expanded(child: _TinyMetric(label: 'Converted', value: '${model.territoryConvertedTotal}', color: _FieldPerformanceScreenState._green)),
              const SizedBox(width: 8),
              Expanded(child: _TinyMetric(label: 'New customers', value: '${model.territoryNewCustomerTotal}', color: _FieldPerformanceScreenState._primary)),
            ],
          ),
          const SizedBox(height: 11),
          _SectionTitle(title: 'Territory performance • ${model.monthLabel}'),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const _SimpleEmpty(
              icon: Icons.map_outlined,
              title: 'No territory activity',
              message: 'No leads, conversions, or new customers are available for this period.',
            )
          else
            ...entries.asMap().entries.map(
              (indexed) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _TerritoryCard(entry: indexed.value, index: indexed.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _TinyMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TinyMetric({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: _FieldPerformanceScreenState._border)),
      child: Column(
        children: <Widget>[
          Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 8.8)),
        ],
      ),
    );
  }
}

class _TerritoryCard extends StatelessWidget {
  final TerritorySummary entry;
  final int index;

  const _TerritoryCard({required this.entry, required this.index});

  static const colors = <Color>[
    Color(0xFF1769E0),
    Color(0xFF7A4DE8),
    Color(0xFF079669),
    Color(0xFFE77917),
    Color(0xFFD94C86),
    Color(0xFF0D9488),
  ];

  @override
  Widget build(BuildContext context) {
    final color = colors[index % colors.length];
    final leads = _integer(entry.leads);
    final converted = _integer(entry.converted);
    final newCustomers = _integer(entry.newCustomers);
    final ratio = leads <= 0 ? 0.0 : (converted / leads).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _FieldPerformanceScreenState._border),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x07112244), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text(
                  entry.territory.trim().isEmpty ? '?' : entry.territory.trim()[0].toUpperCase(),
                  style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.territory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: color.withOpacity(.09), borderRadius: BorderRadius.circular(20)),
                child: Text('$leads leads', style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: <Widget>[
              Expanded(child: _TerritoryValue(label: 'New customers', value: '$newCustomers', color: _FieldPerformanceScreenState._primary)),
              Container(width: 1, height: 30, color: const Color(0xFFEEF1F5)),
              Expanded(child: _TerritoryValue(label: 'Converted leads', value: '$converted', color: _FieldPerformanceScreenState._green)),
              Container(width: 1, height: 30, color: const Color(0xFFEEF1F5)),
              Expanded(child: _TerritoryValue(label: 'Conversion', value: '${(ratio * 100).toStringAsFixed(0)}%', color: color)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: const Color(0xFFE8EDF4),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerritoryValue extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TerritoryValue({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 8.5)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: _FieldPerformanceScreenState._border)),
      child: Row(
        children: <Widget>[
          Container(width: 37, height: 37, decoration: BoxDecoration(color: color.withOpacity(.09), borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: color, size: 19)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.subtitle, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: _FieldPerformanceScreenState._border), boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x09112244), blurRadius: 12, offset: Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: _FieldPerformanceScreenState._primary, size: 19)),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 9.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 14, fontWeight: FontWeight.w800));
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _InfoBanner({required this.icon, required this.message, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(.07), borderRadius: BorderRadius.circular(12)),
      child: Row(children: <Widget>[Icon(icon, color: color, size: 17), const SizedBox(width: 8), Expanded(child: Text(message, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 10.5, height: 1.3)))]),
    );
  }
}

class _SimpleEmpty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const _SimpleEmpty({required this.icon, required this.title, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: _FieldPerformanceScreenState._border)),
      child: Column(children: <Widget>[Icon(icon, color: const Color(0xFF98A2B3), size: 29), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 10.5, height: 1.35))]),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(11)),
      child: Row(children: <Widget>[const Icon(Icons.error_outline_rounded, color: _FieldPerformanceScreenState._red, size: 17), const SizedBox(width: 7), Expanded(child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9F1C1C), fontSize: 10.5))), TextButton(onPressed: onRetry, child: const Text('Retry', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)))]),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: <Widget>[_box(170, 20), const SizedBox(height: 11), _box(43, 14), const SizedBox(height: 11), _box(260, 17)]);
  }
  Widget _box(double height, double radius) => Container(height: height, decoration: BoxDecoration(color: const Color(0xFFE7ECF3), borderRadius: BorderRadius.circular(radius)));
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x18112244), blurRadius: 18)]),
      child: const Row(mainAxisSize: MainAxisSize.min, children: <Widget>[SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: _FieldPerformanceScreenState._primary)), SizedBox(width: 9), Text('Updating…', style: TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 11.5, fontWeight: FontWeight.w600))]),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(children: <Widget>[const CircleAvatar(radius: 31, backgroundColor: Color(0xFFFFE8E8), child: Icon(Icons.cloud_off_rounded, color: _FieldPerformanceScreenState._red, size: 29)), const SizedBox(height: 13), const Text('Could not load field data', style: TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 16, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _FieldPerformanceScreenState._muted, fontSize: 11.5, height: 1.4)), const SizedBox(height: 16), FilledButton.icon(onPressed: onRetry, style: FilledButton.styleFrom(backgroundColor: _FieldPerformanceScreenState._primary, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11)), icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Try again'))]),
      ),
    );
  }
}

class _MonthPicker extends StatefulWidget {
  final DateTime selected;
  const _MonthPicker({required this.selected});
  @override
  State<_MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  late int year;
  static const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  @override
  void initState() { super.initState(); year = widget.selected.year; }
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottom),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD8DEE8), borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 14),
        Row(children: <Widget>[const Expanded(child: Text('Select month', style: TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 17, fontWeight: FontWeight.w800))), IconButton(onPressed: () => setState(() => year--), icon: const Icon(Icons.chevron_left_rounded)), Text('$year', style: const TextStyle(color: _FieldPerformanceScreenState._ink, fontSize: 14, fontWeight: FontWeight.w700)), IconButton(onPressed: year < now.year ? () => setState(() => year++) : null, icon: const Icon(Icons.chevron_right_rounded))]),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.3, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemBuilder: (_, index) {
            final value = DateTime(year, index + 1, 1);
            final selected = widget.selected.year == year && widget.selected.month == index + 1;
            final future = value.isAfter(DateTime(now.year, now.month, 1));
            return Material(
              color: selected ? _FieldPerformanceScreenState._primary : const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(onTap: future ? null : () => Navigator.pop<DateTime>(context, value), borderRadius: BorderRadius.circular(11), child: Center(child: Text(months[index], style: TextStyle(color: future ? const Color(0xFFB8C0CC) : selected ? Colors.white : _FieldPerformanceScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w600)))),
            );
          },
        ),
      ]),
    );
  }
}

int _integer(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _dayLabel(String? value) {
  final date = DateTime.tryParse(value ?? '');
  if (date == null) return '--';
  return '${date.day}/${date.month}';
}
