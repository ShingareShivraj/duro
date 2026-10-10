import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/analytics_filter.dart';
import 'analytics_home_viewmodel.dart';
import 'earnings_targets_screen.dart';
import 'sales_performance_screen.dart';
import 'work_activity_screen.dart';

class AnalyticsHomeScreen extends StatefulWidget {
  final AnalyticsFilter? initialFilter;

  const AnalyticsHomeScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<AnalyticsHomeScreen> createState() => _AnalyticsHomeScreenState();
}

class _AnalyticsHomeScreenState extends State<AnalyticsHomeScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF1769E0);
  static const Color _deepBlue = Color(0xFF0C3F9F);
  static const Color _background = Color(0xFFF4F7FC);
  static const Color _ink = Color(0xFF14213D);
  static const Color _muted = Color(0xFF667085);

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .018),
      end: Offset.zero,
    ).animate(_fadeAnimation);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AnalyticsHomeViewModel>.reactive(
      viewModelBuilder: () => AnalyticsHomeViewModel(
        initialFilter: widget.initialFilter,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: _background,
          appBar: _buildAppBar(context),
          body: SafeArea(
            top: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 28),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          _PeriodHeader(
                            monthLabel: model.selectedMonthLabel,
                            canMoveForward: model.canMoveToNextMonth,
                            onPrevious: model.previousMonth,
                            onNext: model.nextMonth,
                            onSelectMonth: () => _selectMonth(context, model),
                          ),
                          const SizedBox(height: 17),
                          const _SectionTitle(
                            title: 'Explore analytics',
                            subtitle:
                            'Open a section to load its latest insights',
                          ),
                          const SizedBox(height: 10),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cards = _buildDestinationCards(
                                context,
                                model,
                              );

                              if (constraints.maxWidth < 700) {
                                return Column(
                                  children: _spaced(cards, 11),
                                );
                              }

                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.72,
                                children: cards,
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          const _LazyLoadingNote(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        'Analytics',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -.2,
        ),
      ),
    );
  }

  List<Widget> _buildDestinationCards(
      BuildContext context,
      AnalyticsHomeViewModel model,
      ) {
    return <Widget>[
      _AnalyticsFeatureCard(
        number: '01',
        title: 'Earnings & Targets',
        subtitle:
        'Targets, commission milestones and customer opportunities',
        icon: Icons.account_balance_wallet_rounded,
        accent: _primary,
        softColor: const Color(0xFFE8F1FF),
        tags: const <String>['Targets', 'Commission', 'Weekly'],
        preview: const _MilestonePreview(),
        onTap: () => _openScreen(
          context,
          EarningsTargetsScreen(initialFilter: model.filter),
        ),
      ),
      _AnalyticsFeatureCard(
        number: '02',
        title: 'Sales Performance',
        subtitle: 'Sales trends, rankings and territory comparison',
        icon: Icons.show_chart_rounded,
        accent: const Color(0xFF6E51E8),
        softColor: const Color(0xFFF0ECFF),
        tags: const <String>['Trends', 'Leaderboard', 'Territories'],
        preview: const _SalesTrendPreview(),
        onTap: () => _openScreen(
          context,
          SalesPerformanceScreen(initialFilter: model.filter),
        ),
      ),
      _AnalyticsFeatureCard(
        number: '03',
        title: 'Work Activity',
        subtitle: 'Attendance, visits, tours, orders, leads and leaves',
        icon: Icons.dashboard_customize_rounded,
        accent: const Color(0xFF059669),
        softColor: const Color(0xFFE5F8F1),
        tags: const <String>['Attendance', 'Visits', 'Orders'],
        preview: const _WorkActivityPreview(),
        onTap: () => _openScreen(
          context,
          WorkActivityScreen(initialFilter: model.filter),
        ),
      ),
    ];
  }

  Future<void> _openScreen(BuildContext context, Widget screen) async {
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, animation, secondaryAnimation) => screen,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(.035, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectMonth(
      BuildContext context,
      AnalyticsHomeViewModel model,
      ) async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPickerSheet(
        selectedMonth: model.selectedMonth,
      ),
    );

    if (!mounted || selected == null) return;
    model.selectMonth(selected);
  }

  static List<Widget> _spaced(List<Widget> children, double spacing) {
    return <Widget>[
      for (int index = 0; index < children.length; index++) ...<Widget>[
        children[index],
        if (index != children.length - 1) SizedBox(height: spacing),
      ],
    ];
  }
}

class _PeriodHeader extends StatelessWidget {
  final String monthLabel;
  final bool canMoveForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSelectMonth;

  const _PeriodHeader({
    required this.monthLabel,
    required this.canMoveForward,
    required this.onPrevious,
    required this.onNext,
    required this.onSelectMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECF4)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D102A56),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              _HeaderIcon(),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sales Intelligence',
                      style: TextStyle(
                        color: _AnalyticsHomeScreenState._ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Focused insights, loaded only when needed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _AnalyticsHomeScreenState._muted,
                        fontSize: 11.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: <Widget>[
                _PeriodArrow(
                  tooltip: 'Previous month',
                  icon: Icons.chevron_left_rounded,
                  onPressed: onPrevious,
                ),
                Expanded(
                  child: InkWell(
                    onTap: onSelectMonth,
                    borderRadius: BorderRadius.circular(11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: _AnalyticsHomeScreenState._primary,
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            monthLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _AnalyticsHomeScreenState._ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Color(0xFF78859A),
                        ),
                      ],
                    ),
                  ),
                ),
                _PeriodArrow(
                  tooltip: 'Next month',
                  icon: Icons.chevron_right_rounded,
                  onPressed: canMoveForward ? onNext : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            _AnalyticsHomeScreenState._deepBlue,
            _AnalyticsHomeScreenState._primary,
          ],
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(
        Icons.insights_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

class _PeriodArrow extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  const _PeriodArrow({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        icon: Icon(
          icon,
          size: 21,
          color: onPressed == null
              ? const Color(0xFFC3CAD5)
              : _AnalyticsHomeScreenState._primary,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: _AnalyticsHomeScreenState._ink,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -.15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            color: _AnalyticsHomeScreenState._muted,
            fontSize: 11.5,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _AnalyticsFeatureCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color softColor;
  final List<String> tags;
  final Widget preview;
  final VoidCallback onTap;

  const _AnalyticsFeatureCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.softColor,
    required this.tags,
    required this.preview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accent.withOpacity(.07),
        highlightColor: accent.withOpacity(.035),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7ECF4)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D102A56),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: accent, size: 22),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _AnalyticsHomeScreenState._ink,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _AnalyticsHomeScreenState._muted,
                            fontSize: 11.4,
                            height: 1.32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        number,
                        style: TextStyle(
                          color: accent.withOpacity(.55),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 29,
                        height: 29,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FB),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF748198),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 13),
              preview,
              const SizedBox(height: 11),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags
                    .map(
                      (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestonePreview extends StatelessWidget {
  const _MilestonePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: <Widget>[
          _MilestoneDot(active: true),
          Expanded(child: _MilestoneLine(active: true)),
          _MilestoneDot(active: true),
          Expanded(child: _MilestoneLine(active: false)),
          _MilestoneDot(active: false),
          Expanded(child: _MilestoneLine(active: false)),
          _MilestoneDot(active: false),
        ],
      ),
    );
  }
}

class _MilestoneDot extends StatelessWidget {
  final bool active;

  const _MilestoneDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? _AnalyticsHomeScreenState._primary
            : const Color(0xFFDCE3EE),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x181769E0), blurRadius: 4),
        ],
      ),
    );
  }
}

class _MilestoneLine extends StatelessWidget {
  final bool active;

  const _MilestoneLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      color: active
          ? _AnalyticsHomeScreenState._primary
          : const Color(0xFFDCE3EE),
    );
  }
}

class _SalesTrendPreview extends StatelessWidget {
  const _SalesTrendPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _MiniTrendPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MiniTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE7ECF4)
      ..strokeWidth = 1;
    for (int index = 1; index < 4; index++) {
      final y = size.height * index / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[
      Offset(0, size.height * .76),
      Offset(size.width * .14, size.height * .58),
      Offset(size.width * .29, size.height * .66),
      Offset(size.width * .43, size.height * .35),
      Offset(size.width * .57, size.height * .47),
      Offset(size.width * .72, size.height * .20),
      Offset(size.width * .86, size.height * .31),
      Offset(size.width, size.height * .12),
    ];

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath
      ..lineTo(points.last.dx, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0x336E51E8),
            Color(0x006E51E8),
          ],
        ).createShader(Offset.zero & size),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int index = 1; index < points.length; index++) {
      linePath.lineTo(points[index].dx, points[index].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF6E51E8)
        ..strokeWidth = 2.3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WorkActivityPreview extends StatelessWidget {
  const _WorkActivityPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _ActivityIcon(
            icon: Icons.how_to_reg_rounded,
            color: Color(0xFF059669),
            label: 'Attendance',
          ),
          _ActivityIcon(
            icon: Icons.location_on_rounded,
            color: Color(0xFF1769E0),
            label: 'Visits',
          ),
          _ActivityIcon(
            icon: Icons.shopping_bag_rounded,
            color: Color(0xFFE77917),
            label: 'Orders',
          ),
          _ActivityIcon(
            icon: Icons.group_add_rounded,
            color: Color(0xFF7A4DE8),
            label: 'Leads',
          ),
        ],
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _ActivityIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: _AnalyticsHomeScreenState._muted,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LazyLoadingNote extends StatelessWidget {
  const _LazyLoadingNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.speed_rounded,
            size: 18,
            color: _AnalyticsHomeScreenState._primary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Detailed data loads only after you open a section.',
              style: TextStyle(
                color: Color(0xFF3D5F91),
                fontSize: 11.3,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

  @override
  void initState() {
    super.initState();
    _year = widget.selectedMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomPadding),
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
                    color: _AnalyticsHomeScreenState._ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Previous year',
                onPressed: () => setState(() => _year--),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '$_year',
                style: const TextStyle(
                  color: _AnalyticsHomeScreenState._ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                tooltip: 'Next year',
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
              final isFuture = value.isAfter(
                DateTime(now.year, now.month, 1),
              );
              final selected = widget.selectedMonth.year == _year &&
                  widget.selectedMonth.month == month;

              return Material(
                color: selected
                    ? _AnalyticsHomeScreenState._primary
                    : const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: isFuture
                      ? null
                      : () => Navigator.pop<DateTime>(context, value),
                  borderRadius: BorderRadius.circular(11),
                  child: Center(
                    child: Text(
                      _months[index],
                      style: TextStyle(
                        color: isFuture
                            ? const Color(0xFFB9C0CC)
                            : selected
                            ? Colors.white
                            : _AnalyticsHomeScreenState._ink,
                        fontSize: 12.5,
                        fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w600,
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
