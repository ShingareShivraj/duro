import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../model/analytics_filter.dart';
import 'work_activity_viewmodel.dart';

class WorkActivityScreen extends StatefulWidget {
  final AnalyticsFilter initialFilter;

  const WorkActivityScreen({
    super.key,
    required this.initialFilter,
  });

  @override
  State<WorkActivityScreen> createState() => _WorkActivityScreenState();
}

class _WorkActivityScreenState extends State<WorkActivityScreen>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF1769E0);
  static const _deepBlue = Color(0xFF0F4FB7);
  static const _green = Color(0xFF079669);
  static const _purple = Color(0xFF7A4DE8);
  static const _orange = Color(0xFFF59E0B);
  static const _red = Color(0xFFDC4C4C);
  static const _teal = Color(0xFF0D9488);
  static const _ink = Color(0xFF14213D);
  static const _muted = Color(0xFF667085);
  static const _border = Color(0xFFE5EAF2);
  static const _background = Color(0xFFF4F7FC);

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkActivityViewModel>.reactive(
      viewModelBuilder: () => WorkActivityViewModel(
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
              'Work Activity',
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

  Widget _body(WorkActivityViewModel model) {
    if (model.isInitialLoading) return const _LoadingState();

    if (!model.hasData) {
      return _ErrorState(
        message: model.errorMessage ?? 'Work activity is unavailable.',
        onRetry: model.retry,
      );
    }

    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: model.refresh,
          color: _primary,
          child: FadeTransition(
            opacity: _animation,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 25),
              children: <Widget>[
                _WorkHeader(model: model),
                if (model.hasError) ...<Widget>[
                  const SizedBox(height: 8),
                  _InlineError(
                    message: model.errorMessage!,
                    onRetry: model.retry,
                  ),
                ],
                const SizedBox(height: 16),
                const _SectionHeading(
                  title: 'Field & business',
                  subtitle: 'Your customer-facing work for the selected month',
                ),
                const SizedBox(height: 9),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final ratio = constraints.maxWidth >= 600 ? 2.15 : 1.52;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: constraints.maxWidth >= 600 ? 4 : 2,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                      childAspectRatio: ratio,
                      children: <Widget>[
                        _ActivityCard(
                          icon: Icons.pin_drop_rounded,
                          title: 'Visits',
                          value: model.visits,
                          color: _primary,
                          caption: 'Customer visits',
                        ),
                        _ActivityCard(
                          icon: Icons.directions_car_filled_rounded,
                          title: 'Tours',
                          value: model.tours,
                          color: _teal,
                          caption: 'Field tours',
                        ),
                        _ActivityCard(
                          icon: Icons.shopping_bag_rounded,
                          title: 'Orders',
                          value: model.orders,
                          color: _purple,
                          caption: 'Sales orders',
                        ),
                        _ActivityCard(
                          icon: Icons.person_search_rounded,
                          title: 'Leads',
                          value: model.leads,
                          color: _orange,
                          caption: 'Leads created',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 17),
                const _SectionHeading(
                  title: 'People & time',
                  subtitle: 'Attendance and leave records for the period',
                ),
                const SizedBox(height: 9),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _PeopleCard(
                        icon: Icons.how_to_reg_rounded,
                        label: 'Present days',
                        value: model.attendance,
                        color: _green,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _PeopleCard(
                        icon: Icons.beach_access_rounded,
                        label: 'Leave requests',
                        value: model.leaves,
                        color: _red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (!model.hasAnyActivity)
                  _EmptyActivity(monthLabel: model.monthLabel)
                else
                  const _SourceNote(),
              ],
            ),
          ),
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

class _WorkHeader extends StatelessWidget {
  final WorkActivityViewModel model;

  const _WorkHeader({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            _WorkActivityScreenState._deepBlue,
            _WorkActivityScreenState._primary,
            Color(0xFF3F8EF4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x251769E0),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -30,
            bottom: -52,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.055),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.employeeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          model.companyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.70),
                            fontSize: 10,
                          ),
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
                  _WorkPulse(value: model.workActions),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Work pulse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${model.workActions} business actions recorded during ${model.monthLabel}.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.76),
                            fontSize: 10.5,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: <Widget>[
                            _HeaderChip(
                              icon: Icons.how_to_reg_rounded,
                              label: '${model.attendance} present',
                            ),
                            const SizedBox(width: 7),
                            _HeaderChip(
                              icon: Icons.beach_access_rounded,
                              label: '${model.leaves} leaves',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkPulse extends StatelessWidget {
  final int value;

  const _WorkPulse({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: CustomPaint(
        painter: _PulsePainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'ACTIONS',
              style: TextStyle(
                color: Colors.white.withOpacity(.66),
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: .6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.white.withOpacity(.16),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.13),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthControl extends StatelessWidget {
  final WorkActivityViewModel model;

  const _MonthControl({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _arrow(Icons.chevron_left_rounded, model.previousMonth),
          InkWell(
            onTap: () => _pickMonth(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
          _arrow(
            Icons.chevron_right_rounded,
            model.canMoveToNextMonth ? model.nextMonth : null,
          ),
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
      icon: Icon(
        icon,
        size: 19,
        color: action == null ? Colors.white.withOpacity(.3) : Colors.white,
      ),
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthPicker(selected: model.filter.month),
    );
    if (selected != null) await model.changeMonth(selected);
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final Color color;
  final String caption;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _WorkActivityScreenState._border),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x08112244), blurRadius: 11, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '$value',
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _WorkActivityScreenState._ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _WorkActivityScreenState._muted,
                    fontSize: 8.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeopleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _PeopleCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[color.withOpacity(.09), color.withOpacity(.035)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.14)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.75),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$value',
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _WorkActivityScreenState._muted,
                    fontSize: 9.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: _WorkActivityScreenState._ink,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            color: _WorkActivityScreenState._muted,
            fontSize: 10.2,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _SourceNote extends StatelessWidget {
  const _SourceNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.verified_user_outlined,
            color: _WorkActivityScreenState._primary,
            size: 17,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'All values come directly from your ERPNext records for the selected month.',
              style: TextStyle(
                color: Color(0xFF46668F),
                fontSize: 10.3,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  final String monthLabel;

  const _EmptyActivity({required this.monthLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _WorkActivityScreenState._border),
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFEAF2FF),
            child: Icon(
              Icons.inbox_outlined,
              color: _WorkActivityScreenState._primary,
              size: 25,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'No activity in $monthLabel',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _WorkActivityScreenState._ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Visits, tours, orders, leads, attendance, and leave records will appear here when available.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _WorkActivityScreenState._muted,
              fontSize: 10.5,
              height: 1.4,
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.error_outline_rounded,
            color: _WorkActivityScreenState._red,
            size: 17,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF9F1C1C), fontSize: 10.5),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
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
        _box(215, 20),
        const SizedBox(height: 16),
        _box(18, 5),
        const SizedBox(height: 9),
        Row(
          children: <Widget>[
            Expanded(child: _box(92, 16)),
            const SizedBox(width: 9),
            Expanded(child: _box(92, 16)),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          children: <Widget>[
            Expanded(child: _box(92, 16)),
            const SizedBox(width: 9),
            Expanded(child: _box(92, 16)),
          ],
        ),
      ],
    );
  }

  Widget _box(double height, double radius) => Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE7ECF3),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x18112244), blurRadius: 18),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: _WorkActivityScreenState._primary,
            ),
          ),
          SizedBox(width: 9),
          Text(
            'Updating…',
            style: TextStyle(
              color: _WorkActivityScreenState._ink,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: <Widget>[
            const CircleAvatar(
              radius: 31,
              backgroundColor: Color(0xFFFFE8E8),
              child: Icon(
                Icons.cloud_off_rounded,
                color: _WorkActivityScreenState._red,
                size: 29,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Could not load work activity',
              style: TextStyle(
                color: _WorkActivityScreenState._ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _WorkActivityScreenState._muted,
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: _WorkActivityScreenState._primary,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              ),
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

  static const months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD8DEE8),
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
                    color: _WorkActivityScreenState._ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => year--),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '$year',
                style: const TextStyle(
                  color: _WorkActivityScreenState._ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: year < now.year ? () => setState(() => year++) : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (_, index) {
              final value = DateTime(year, index + 1, 1);
              final selected = widget.selected.year == year &&
                  widget.selected.month == index + 1;
              final future = value.isAfter(DateTime(now.year, now.month, 1));

              return Material(
                color: selected
                    ? _WorkActivityScreenState._primary
                    : const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: future
                      ? null
                      : () => Navigator.pop<DateTime>(context, value),
                  borderRadius: BorderRadius.circular(11),
                  child: Center(
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: future
                            ? const Color(0xFFB8C0CC)
                            : selected
                                ? Colors.white
                                : _WorkActivityScreenState._ink,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
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
