import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import '../../model/dashboard.dart';
import 'earnings_targets_viewmodel.dart';

class EarningsTargetsScreen extends StatefulWidget {
  final AnalyticsFilter initialFilter;

  const EarningsTargetsScreen({
    super.key,
    required this.initialFilter,
  });

  @override
  State<EarningsTargetsScreen> createState() => _EarningsTargetsScreenState();
}

class _EarningsTargetsScreenState extends State<EarningsTargetsScreen>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF1769E0);
  static const _primaryDark = Color(0xFF0F4FB7);
  static const _green = Color(0xFF079669);
  static const _orange = Color(0xFFF59E0B);
  static const _ink = Color(0xFF14213D);
  static const _muted = Color(0xFF667085);
  static const _border = Color(0xFFE5EAF2);
  static const _background = Color(0xFFF4F7FC);

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EarningsTargetsViewModel>.reactive(
      viewModelBuilder: () => EarningsTargetsViewModel(
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
              'Earnings & Targets',
              style: TextStyle(
                color: _ink,
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -.25,
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

  Widget _buildBody(BuildContext context, EarningsTargetsViewModel model) {
    if (model.isInitialLoading) return const _LoadingState();

    if (!model.hasData) {
      return _ErrorState(
        message: model.errorMessage ??
            'Commission information is not available for this period.',
        onRetry: model.retry,
      );
    }

    final dashboard = model.dashboard!;
    final summary = model.summary!;

    return Stack(
      children: <Widget>[
        NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  _TopCard(model: model, summary: summary),
                  if (model.isSalesManager) ...<Widget>[
                    const SizedBox(height: 9),
                    _SalesPersonSelector(model: model),
                  ],
                  if (model.hasError) ...<Widget>[
                    const SizedBox(height: 8),
                    _InlineError(
                      message: model.errorMessage!,
                      onRetry: model.retry,
                    ),
                  ],
                ]),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabsHeaderDelegate(
                child: _AnalyticsTabs(
                  controller: _tabController,
                  customerCount: model.customerOpportunities.length,
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _OverviewTab(
                summary: summary,
                dashboard: dashboard,
                onRefresh: model.refresh,
              ),
              _CustomersTab(
                model: model,
                onRefresh: model.refresh,
              ),
              _WeeklyTab(
                weeks: model.weeks,
                currency: model.currency,
                onRefresh: model.refresh,
              ),
            ],
          ),
        ),
        if (model.isRefreshing)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: _background.withOpacity(.60),
                alignment: Alignment.center,
                child: const _LoadingPill(),
              ),
            ),
          ),
      ],
    );
  }
}

class _TopCard extends StatelessWidget {
  final EarningsTargetsViewModel model;
  final CommissionSummary summary;

  const _TopCard({required this.model, required this.summary});

  @override
  Widget build(BuildContext context) {
    final progress = summary.progress;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            _EarningsTargetsScreenState._primaryDark,
            _EarningsTargetsScreenState._primary,
            Color(0xFF3A8CF5),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x251769E0),
            blurRadius: 16,
            offset: Offset(0, 6),
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
                      model.personCaption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.75),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _money(summary.totalCommission, model.currency),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Total commission earned',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.78),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              _MonthControl(model: model),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _HeroMetric(
                  label: 'Sales',
                  value: _compactMoney(summary.totalSales, model.currency),
                ),
              ),
              _heroDivider(),
              Expanded(
                child: _HeroMetric(
                  label: 'Target',
                  value: _compactMoney(summary.monthlyTarget, model.currency),
                ),
              ),
              _heroDivider(),
              Expanded(
                child: _HeroMetric(
                  label: 'Achieved',
                  value: '${summary.achievementPercent.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  summary.targetAchieved
                      ? 'Monthly target achieved'
                      : '${_compactMoney(summary.targetRemaining, model.currency)} remaining',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.82),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                model.monthLabel,
                style: TextStyle(
                  color: Colors.white.withOpacity(.82),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _heroDivider() => Container(
    height: 32,
    width: 1,
    color: Colors.white.withOpacity(.20),
  );
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(.68),
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MonthControl extends StatelessWidget {
  final EarningsTargetsViewModel model;

  const _MonthControl({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _smallArrow(Icons.chevron_left_rounded, model.previousMonth),
          InkWell(
            onTap: () => _showMonthPicker(context, model),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
          _smallArrow(
            Icons.chevron_right_rounded,
            model.canMoveToNextMonth ? model.nextMonth : null,
          ),
        ],
      ),
    );
  }

  Widget _smallArrow(IconData icon, VoidCallback? onTap) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 31, height: 34),
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        size: 19,
        color: onTap == null ? Colors.white.withOpacity(.3) : Colors.white,
      ),
    );
  }

  Future<void> _showMonthPicker(
      BuildContext context,
      EarningsTargetsViewModel model,
      ) async {
    final value = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPicker(selected: model.filter.month),
    );
    if (value != null) await model.changeMonth(value);
  }
}

class _SalesPersonSelector extends StatelessWidget {
  final EarningsTargetsViewModel model;

  const _SalesPersonSelector({required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.salesPersons.isEmpty) {
      return const _InfoBanner(
        icon: Icons.people_outline_rounded,
        message: 'No Sales Persons are available for your company.',
        color: _EarningsTargetsScreenState._orange,
      );
    }

    final validSelection = model.salesPersons.any(
          (person) => person.name == model.selectedSalesPerson,
    );

    return DropdownButtonFormField<String>(
      value: validSelection ? model.selectedSalesPerson : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Sales Person',
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: const Icon(
          Icons.person_search_rounded,
          color: _EarningsTargetsScreenState._primary,
          size: 19,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        border: _outline(),
        enabledBorder: _outline(),
        focusedBorder: _outline(
          color: _EarningsTargetsScreenState._primary,
          width: 1.4,
        ),
      ),
      items: model.salesPersons
          .map(
            (person) => DropdownMenuItem<String>(
          value: person.name,
          child: Text(
            person.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ),
      )
          .toList(),
      onChanged: model.isBusy ? null : model.changeSalesPerson,
    );
  }

  static OutlineInputBorder _outline({
    Color color = _EarningsTargetsScreenState._border,
    double width = 1,
  }) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: color, width: width),
      );
}

class _AnalyticsTabs extends StatelessWidget {
  final TabController controller;
  final int customerCount;

  const _AnalyticsTabs({required this.controller, required this.customerCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x10112244), blurRadius: 7, offset: Offset(0, 2)),
          ],
        ),
        labelColor: _EarningsTargetsScreenState._primary,
        unselectedLabelColor: _EarningsTargetsScreenState._muted,
        labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
        const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
        tabs: <Widget>[
          const Tab(text: 'Overview'),
          Tab(text: customerCount > 0 ? 'Customers ($customerCount)' : 'Customers'),
          const Tab(text: 'Weekly'),
        ],
      ),
    );
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _TabsHeaderDelegate({required this.child});

  @override
  double get minExtent => 55;

  @override
  double get maxExtent => 55;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _EarningsTargetsScreenState._background,
        boxShadow: overlapsContent
            ? const <BoxShadow>[
          BoxShadow(
            color: Color(0x10112244),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ]
            : const <BoxShadow>[],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabsHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class _OverviewTab extends StatelessWidget {
  final CommissionSummary summary;
  final CommissionDashboard dashboard;
  final Future<void> Function() onRefresh;

  const _OverviewTab({
    required this.summary,
    required this.dashboard,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _EarningsTargetsScreenState._primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
        children: <Widget>[
          _SectionCard(
            title: 'Commission breakdown',
            icon: Icons.pie_chart_rounded,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              childAspectRatio: 1.75,
              children: <Widget>[
                _BreakdownMetric(
                  label: 'Weekly commission',
                  value: _money(summary.weeklyCommission, dashboard.currency),
                  caption: '${summary.weeklyCommissionPercent.toStringAsFixed(2)}% rate',
                  color: const Color(0xFF1769E0),
                  icon: Icons.calendar_view_week_rounded,
                ),
                _BreakdownMetric(
                  label: 'Target commission',
                  value: _money(summary.targetCommission, dashboard.currency),
                  caption: '${summary.slabCommissionPercent.toStringAsFixed(2)}% slab',
                  color: const Color(0xFF7A4DE8),
                  icon: Icons.track_changes_rounded,
                ),
                _BreakdownMetric(
                  label: 'New customers',
                  value: _money(summary.newCustomerCommission, dashboard.currency),
                  caption: 'Additional earning',
                  color: const Color(0xFF079669),
                  icon: Icons.person_add_alt_1_rounded,
                ),
                _BreakdownMetric(
                  label: 'Reactivated',
                  value: _money(summary.inactiveToActiveCommission, dashboard.currency),
                  caption: 'Additional earning',
                  color: const Color(0xFFE77917),
                  icon: Icons.autorenew_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          _SectionCard(
            title: 'Commission journey',
            icon: Icons.route_rounded,
            child: dashboard.milestones.isEmpty
                ? const _NoMilestones()
                : _MilestoneFlow(
              milestones: dashboard.milestones,
              achievement: summary.achievementPercent,
            ),
          ),
          if (dashboard.nextGoal != null) ...<Widget>[
            const SizedBox(height: 10),
            _NextGoalCard(goal: dashboard.nextGoal!, currency: dashboard.currency),
          ],
        ],
      ),
    );
  }
}

class _CustomersTab extends StatelessWidget {
  final EarningsTargetsViewModel model;
  final Future<void> Function() onRefresh;

  const _CustomersTab({required this.model, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final opportunities = model.customerOpportunities;
    final summary = model.customerOpportunitySummary;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _EarningsTargetsScreenState._primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
        children: <Widget>[
          if (opportunities.isNotEmpty) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _MiniSummary(
                    label: 'In progress',
                    value: '${summary.inProgressCustomers}',
                    color: _EarningsTargetsScreenState._orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniSummary(
                    label: 'Earned',
                    value: '${summary.earnedCustomers}',
                    color: _EarningsTargetsScreenState._green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniSummary(
                    label: 'Potential',
                    value: _compactMoney(summary.potentialCommission, model.currency),
                    color: _EarningsTargetsScreenState._primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...opportunities.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _CustomerOpportunityCard(
                  opportunity: item,
                  currency: model.currency,
                ),
              ),
            ),
          ] else
            _CustomerEmpty(
              title: model.customerEmptyTitle,
              message: model.customerEmptyMessage,
              isManager: model.isSalesManager,
            ),
        ],
      ),
    );
  }
}

class _WeeklyTab extends StatelessWidget {
  final List<CommissionWeek> weeks;
  final String currency;
  final Future<void> Function() onRefresh;

  const _WeeklyTab({
    required this.weeks,
    required this.currency,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _EarningsTargetsScreenState._primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
        children: <Widget>[
          const _InfoBanner(
            icon: Icons.info_outline_rounded,
            message: 'Weekly sales and commission come directly from the configured ERPNext report.',
            color: _EarningsTargetsScreenState._primary,
          ),
          const SizedBox(height: 10),
          if (weeks.isEmpty)
            const _SimpleEmpty(
              icon: Icons.calendar_view_week_outlined,
              title: 'No weekly activity',
              message: 'No weekly sales information is available for this month.',
            )
          else
            ...weeks.map(
                  (week) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _WeekCard(week: week, currency: currency),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _EarningsTargetsScreenState._border),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x09112244), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: _EarningsTargetsScreenState._primary, size: 19),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  color: _EarningsTargetsScreenState._ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BreakdownMetric extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final Color color;
  final IconData icon;

  const _BreakdownMetric({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(.065),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _EarningsTargetsScreenState._muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 8.8),
          ),
        ],
      ),
    );
  }
}

class _MilestoneFlow extends StatelessWidget {
  final List<CommissionMilestone> milestones;
  final double achievement;

  const _MilestoneFlow({required this.milestones, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int index = 0; index < milestones.length; index++) ...<Widget>[
            _MilestoneNode(
              milestone: milestones[index],
              reached: milestones[index].isReached ||
                  achievement >= milestones[index].fromTargetPercent,
              current: milestones[index].isCurrent,
            ),
            if (index != milestones.length - 1)
              Container(
                width: 34,
                height: 2,
                margin: const EdgeInsets.only(top: 20),
                color: milestones[index].isReached
                    ? _EarningsTargetsScreenState._green
                    : const Color(0xFFD7DDE8),
              ),
          ],
        ],
      ),
    );
  }
}

class _MilestoneNode extends StatelessWidget {
  final CommissionMilestone milestone;
  final bool reached;
  final bool current;

  const _MilestoneNode({required this.milestone, required this.reached, required this.current});

  @override
  Widget build(BuildContext context) {
    final color = current
        ? _EarningsTargetsScreenState._primary
        : reached
        ? _EarningsTargetsScreenState._green
        : const Color(0xFF98A2B3);

    return SizedBox(
      width: 70,
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: reached ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: current ? 3 : 2),
              boxShadow: current
                  ? <BoxShadow>[
                BoxShadow(color: color.withOpacity(.20), blurRadius: 9, spreadRadius: 2),
              ]
                  : null,
            ),
            child: reached
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Center(
              child: Text(
                '${milestone.fromTargetPercent.toStringAsFixed(0)}',
                style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${milestone.fromTargetPercent.toStringAsFixed(0)}%',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
          ),
          Text(
            '${milestone.commissionPercent.toStringAsFixed(2)}% comm.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 8.5),
          ),
          if (current) ...<Widget>[
            const SizedBox(height: 4),
            const Text(
              'You are here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _EarningsTargetsScreenState._primary,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NextGoalCard extends StatelessWidget {
  final CommissionNextGoal goal;
  final String currency;

  const _NextGoalCard({required this.goal, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[Color(0xFFE9F2FF), Color(0xFFF2F7FF)]),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFCFE1FF)),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xFFD7E8FF),
            child: Icon(Icons.flag_rounded, color: _EarningsTargetsScreenState._primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: '${_money(goal.remainingSales, currency)} more sales ',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: _EarningsTargetsScreenState._ink),
                  ),
                  TextSpan(
                    text: 'to reach ${goal.targetPercent.toStringAsFixed(0)}% and unlock '
                        '${goal.commissionPercent.toStringAsFixed(2)}% commission.',
                  ),
                ],
              ),
              style: const TextStyle(
                color: _EarningsTargetsScreenState._muted,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoMilestones extends StatelessWidget {
  const _NoMilestones();

  @override
  Widget build(BuildContext context) {
    return const _SimpleEmpty(
      icon: Icons.route_outlined,
      title: 'Milestones are not configured',
      message: 'Configure Commission Slab rows for this Sales Person in ERPNext.',
    );
  }
}

class _MiniSummary extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniSummary({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _EarningsTargetsScreenState._border),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 9.2),
          ),
        ],
      ),
    );
  }
}

class _CustomerOpportunityCard extends StatelessWidget {
  final CustomerCommissionOpportunity opportunity;
  final String currency;

  const _CustomerOpportunityCard({required this.opportunity, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isNew = opportunity.isNewCustomer;
    final color = isNew
        ? _EarningsTargetsScreenState._green
        : const Color(0xFFE77917);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.16)),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x08112244), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(11)),
                child: Icon(isNew ? Icons.person_add_alt_1_rounded : Icons.autorenew_rounded, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      opportunity.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      opportunity.typeLabel,
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: opportunity.isEarned ? const Color(0xFFE5F8F0) : const Color(0xFFFFF3E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  opportunity.isEarned ? 'Earned' : 'In progress',
                  style: TextStyle(
                    color: opportunity.isEarned ? _EarningsTargetsScreenState._green : _EarningsTargetsScreenState._orange,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text(
                _money(opportunity.currentSales, currency),
                style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800),
              ),
              Text(
                ' of ${_money(opportunity.minimumPurchaseAmount, currency)}',
                style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 10.5),
              ),
              const Spacer(),
              Text(
                '${opportunity.progressPercent.toStringAsFixed(0)}%',
                style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: opportunity.progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE8EDF4),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.isEarned
                ? '${_money(opportunity.commissionAmount, currency)} commission achieved'
                : '${_money(opportunity.remainingSales, currency)} more sales to earn '
                '${_money(opportunity.commissionAmount, currency)} commission',
            style: TextStyle(
              color: opportunity.isEarned ? _EarningsTargetsScreenState._green : _EarningsTargetsScreenState._muted,
              fontSize: 10.5,
              height: 1.3,
              fontWeight: opportunity.isEarned ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (!opportunity.isEarned && opportunity.daysRemaining > 0) ...<Widget>[
            const SizedBox(height: 5),
            Row(
              children: <Widget>[
                const Icon(Icons.schedule_rounded, size: 13, color: _EarningsTargetsScreenState._orange),
                const SizedBox(width: 4),
                Text(
                  '${opportunity.daysRemaining} days remaining',
                  style: const TextStyle(color: _EarningsTargetsScreenState._orange, fontSize: 9.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CustomerEmpty extends StatelessWidget {
  final String title;
  final String message;
  final bool isManager;

  const _CustomerEmpty({required this.title, required this.message, required this.isManager});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[Color(0xFFFFFBEB), Color(0xFFFFF6E8)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF9E3AF)),
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFFFEED0),
            child: Icon(Icons.emoji_events_rounded, color: _EarningsTargetsScreenState._orange, size: 28),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 11, height: 1.4),
          ),
          if (!isManager) ...<Widget>[
            const SizedBox(height: 13),
            const Row(
              children: <Widget>[
                Expanded(child: _ActionHint(icon: Icons.person_add_alt_1_rounded, label: 'New Distributor', color: _EarningsTargetsScreenState._green)),
                SizedBox(width: 8),
                Expanded(child: _ActionHint(icon: Icons.autorenew_rounded, label: 'Reactivate', color: Color(0xFFE77917))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionHint extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionHint({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.8), borderRadius: BorderRadius.circular(11)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  final CommissionWeek week;
  final String currency;

  const _WeekCard({required this.week, required this.currency});

  @override
  Widget build(BuildContext context) {
    final color = week.isCompleted
        ? _EarningsTargetsScreenState._green
        : week.isCurrent
        ? _EarningsTargetsScreenState._primary
        : const Color(0xFF98A2B3);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: week.isCurrent ? const Color(0xFFBFD7FF) : _EarningsTargetsScreenState._border,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: color.withOpacity(.10), shape: BoxShape.circle),
            child: Icon(week.isCompleted ? Icons.check_rounded : Icons.calendar_today_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Week ${week.week}', style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(_dateRange(week.fromDate, week.toDate), style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 9.5)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(_money(week.sales, currency), style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                '${_money(week.commission, currency)} • ${week.commissionPercent.toStringAsFixed(2)}%',
                style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 10.5, height: 1.3))),
        ],
      ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: _EarningsTargetsScreenState._border)),
      child: Column(
        children: <Widget>[
          Icon(icon, color: const Color(0xFF98A2B3), size: 29),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 10.5, height: 1.35)),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(11)),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 17),
          const SizedBox(width: 7),
          Expanded(child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9F1C1C), fontSize: 10.5))),
          TextButton(onPressed: onRetry, child: const Text('Retry', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x18112244), blurRadius: 18)]),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: _EarningsTargetsScreenState._primary)),
          SizedBox(width: 9),
          Text('Updating…', style: TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 11.5, fontWeight: FontWeight.w600)),
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
        _skeleton(height: 210, radius: 20),
        const SizedBox(height: 11),
        _skeleton(height: 48, radius: 13),
        const SizedBox(height: 11),
        _skeleton(height: 43, radius: 14),
        const SizedBox(height: 11),
        _skeleton(height: 210, radius: 17),
      ],
    );
  }

  Widget _skeleton({required double height, required double radius}) =>
      Container(height: height, decoration: BoxDecoration(color: const Color(0xFFE7ECF3), borderRadius: BorderRadius.circular(radius)));
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
        child: Column(
          children: <Widget>[
            const CircleAvatar(radius: 31, backgroundColor: Color(0xFFFFE8E8), child: Icon(Icons.cloud_off_rounded, color: Color(0xFFDC2626), size: 29)),
            const SizedBox(height: 13),
            const Text('Could not load earnings', style: TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _EarningsTargetsScreenState._muted, fontSize: 11.5, height: 1.4)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: _EarningsTargetsScreenState._primary, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11)),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ),
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
  void initState() {
    super.initState();
    year = widget.selected.year;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottom),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD8DEE8), borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              const Expanded(child: Text('Select month', style: TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 17, fontWeight: FontWeight.w800))),
              IconButton(onPressed: () => setState(() => year--), icon: const Icon(Icons.chevron_left_rounded)),
              Text('$year', style: const TextStyle(color: _EarningsTargetsScreenState._ink, fontSize: 14, fontWeight: FontWeight.w700)),
              IconButton(onPressed: year < now.year ? () => setState(() => year++) : null, icon: const Icon(Icons.chevron_right_rounded)),
            ],
          ),
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
                color: selected ? _EarningsTargetsScreenState._primary : const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: future ? null : () => Navigator.pop<DateTime>(context, value),
                  borderRadius: BorderRadius.circular(11),
                  child: Center(
                    child: Text(
                      months[index],
                      style: TextStyle(color: future ? const Color(0xFFB8C0CC) : selected ? Colors.white : _EarningsTargetsScreenState._ink, fontSize: 12.5, fontWeight: FontWeight.w600),
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

String _money(double value, String currency) {
  final symbol = currency.toUpperCase() == 'INR' ? '₹' : '$currency ';
  final absolute = value.abs();
  final decimals = absolute == absolute.roundToDouble() ? 0 : 2;
  return '$symbol${value.toStringAsFixed(decimals)}';
}

String _compactMoney(double value, String currency) {
  final symbol = currency.toUpperCase() == 'INR' ? '₹' : '$currency ';
  final absolute = value.abs();
  if (absolute >= 10000000) return '$symbol${(value / 10000000).toStringAsFixed(2)}Cr';
  if (absolute >= 100000) return '$symbol${(value / 100000).toStringAsFixed(2)}L';
  if (absolute >= 1000) return '$symbol${(value / 1000).toStringAsFixed(1)}K';
  return '$symbol${value.toStringAsFixed(0)}';
}

String _dateRange(String? from, String? to) {
  if ((from == null || from.isEmpty) && (to == null || to.isEmpty)) return 'Date unavailable';
  if (from == to || to == null || to.isEmpty) return _shortDate(from);
  return '${_shortDate(from)} – ${_shortDate(to)}';
}

String _shortDate(String? value) {
  final date = DateTime.tryParse(value ?? '');
  if (date == null) return value ?? '';
  const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day} ${months[date.month - 1]}';
}
