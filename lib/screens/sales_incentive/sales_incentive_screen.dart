import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'sales_incentive_viewmodel.dart';
import '../../widgets/full_screen_loader.dart';
import '../../model/sales_incentive_model.dart';
void main() {
  runApp(const SalesIncentiveApp());
}

class SalesIncentiveApp extends StatelessWidget {
  const SalesIncentiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Incentive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display', // Falls back to system font on Android
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A56CC)),
        useMaterial3: true,
      ),
      home: const SalesIncentiveScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────

class SalesIncentiveScreen extends StatelessWidget {
  const SalesIncentiveScreen({super.key});

  // Sample data — swap with your real API/state






  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesIncentiveViewModel>.reactive(
      viewModelBuilder: () => SalesIncentiveViewModel(),
      onViewModelReady: (model) => model.initialise(),

      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F3EE),

          body: fullScreenLoader(
            context: context,
            loader: model.isBusy,



              child: Column(
                children: [
                  // ── Blue Gradient Header ──
                  _HeaderSection(model: model),

                  // ── Scrollable Content ──
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: model.refresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Target Card
                            _TargetCard(
                              target: model.totalTarget,
                              achieved: model.totalAchieved,
                              pending: model.totalPending,
                              progress: model.overallProgress,
                            ),

                            const SizedBox(height: 16),

                            // Incentive Card
                            _IncentiveCard(
                              thresholdPercent: 100, // not used anymore
                              amount: model.incentiveAmount,
                              isInProgress: model.incentiveAmount == 0,
                            ),

                            const SizedBox(height: 20),

                            // Product Progress List
                            const _SectionLabel(label: 'Product-wise Progress'),
                            const SizedBox(height: 12),

                            ...model.products.map(
                                  (p) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ProductProgressTile(product: p),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Bottom nudge banner

                          ],
                        ),
                      ),
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

// ─────────────────────────────────────────────
// WIDGET: Header
// ─────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {

  final SalesIncentiveViewModel model;

  const _HeaderSection({required this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
      // Blue gradient header with status bar padding
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A56CC), // deep blue
            Color(0xFF2D6EE8), // medium blue
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 🔥 HEADER ROW
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Sales Incentive',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 FILTER ROW (FIXED POSITION)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: model.monthLabel,
                    isSelected: model.selectedPeriod == "monthly",
                    onTap: () => model.setPeriod("monthly"),
                  ),
                  const SizedBox(width: 10),


                  _FilterChip(
                    label: model.fyLabel,
                    isSelected: model.selectedPeriod == "yearly",
                    onTap: () => model.setPeriod("yearly"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: Target Card
// ─────────────────────────────────────────────

class _TargetCard extends StatelessWidget {
  final int target;
  final int achieved;
  final int pending;
  final double progress;

  const _TargetCard({
    required this.target,
    required this.achieved,
    required this.pending,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return _ShadowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Text(
                '🎯',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Target: ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '$target Bags',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Three stat chips
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  icon: Icons.check_rounded,
                  iconColor: const Color(0xFF1A56CC),
                  value: '$target',
                  label: 'Target',
                  bgColor: const Color(0xFFEDF2FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatChip(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF16A34A),
                  value: '$achieved',
                  label: 'Achieved',
                  bgColor: const Color(0xFFEFFCF3),
                  valueColor: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatChip(
                  icon: Icons.hourglass_bottom_rounded,
                  iconColor: const Color(0xFFD97706),
                  value: '$pending',
                  label: 'Pending',
                  bgColor: const Color(0xFFFFF8EC),
                  valueColor: const Color(0xFFD97706),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar with percentage
          _LabeledProgressBar(
            value: progress,
            color: const Color(0xFF16A34A),
            showPercentage: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: Stat Chip (Target / Achieved / Pending)
// ─────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color bgColor;
  final Color? valueColor;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.bgColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: Incentive Card
// ─────────────────────────────────────────────

class _IncentiveCard extends StatelessWidget {
  final int thresholdPercent;
  final double amount;
  final bool isInProgress;

  const _IncentiveCard({
    required this.thresholdPercent,
    required this.amount,
    required this.isInProgress,
  });

  @override
  Widget build(BuildContext context) {
    return _ShadowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Text('💰', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Incentive: ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              Icon(
                Icons.hourglass_bottom_rounded,
                size: 16,
                color: const Color(0xFFD97706),
              ),
              const SizedBox(width: 4),
              Text(
                isInProgress ? 'In Progress' : 'Unlocked 🎉',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isInProgress
                      ? const Color(0xFFD97706)
                      : const Color(0xFF16A34A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Highlighted rule + amount box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFDE68A),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rule line
                Row(
                  children: [
                    Text(
                      'Rule: 100% Against achievement',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    // Text(
                    //   '$thresholdPercent% Target Required',
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w600,
                    //     color: Color(0xFFD97706),
                    //   ),
                    // ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    color: Color(0xFFFDE68A),
                  ),
                ),

                // Amount line
                Row(
                  children: [
                    Text(
                      'Incentive Amount: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
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

// ─────────────────────────────────────────────
// WIDGET: Product Progress Tile
// ─────────────────────────────────────────────

class _ProductProgressTile extends StatelessWidget {
  final ProductProgress product;

  const _ProductProgressTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final Color progressColor = product.isCompleted
        ? const Color(0xFF16A34A) // green for 100%
        : const Color(0xFFD97706); // amber for partial

    return _ShadowCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          // Product name + count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${product.achieved} / ${product.target}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),

                  // 🔥 NEW: INCENTIVE PER PRODUCT
                  if (product.incentive > 0)
                    Text(
                      '₹${product.incentive.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar + percentage
          _LabeledProgressBar(
            value: product.progress,
            color: progressColor,
            showPercentage: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: Incentive Nudge Banner
// ─────────────────────────────────────────────

class _IncentiveNudgeBanner extends StatelessWidget {
  final int bagsNeeded;

  const _IncentiveNudgeBanner({required this.bagsNeeded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFBFD4FF),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Text('👉', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Sell '),
                  TextSpan(
                    text: '$bagsNeeded more bags',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A56CC),
                    ),
                  ),
                  const TextSpan(text: ' to unlock incentive'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE: Labeled Progress Bar
// ─────────────────────────────────────────────

class _LabeledProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color color;
  final bool showPercentage;

  const _LabeledProgressBar({
    required this.value,
    required this.color,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final int pct = (value * 100).round();
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Stack(
              children: [
                // Track
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(width: 10),
          SizedBox(
            width: 38,
            child: Text(
              '$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE: Shadow Card Container
// ─────────────────────────────────────────────

class _ShadowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _ShadowCard({
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE: Section Label
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF374151),
        letterSpacing: -0.2,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 🔥 IMPORTANT
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 90,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}