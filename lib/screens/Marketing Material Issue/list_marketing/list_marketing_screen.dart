import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../add_marketing/add_marketing_screen.dart';
import 'list_marketing_viewmodel.dart';

class _C {
  static const primary     = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1E3A8A);
  static const bg          = Color(0xFFF0F4FF);
  static const surface     = Colors.white;
  static const border      = Color(0xFFDBEAFE);
  static const borderLight = Color(0xFFBFDBFE);
  static const tint        = Color(0xFFEFF6FF);
  static const textHead    = Color(0xFF1E3A8A);
  static const textMuted   = Color(0xFF000000);
  static const green       = Color(0xFF059669);
  static const greenBg     = Color(0xFFD1FAE5);
  static const greenBorder = Color(0xFF86EFAC);
  static const red         = Color(0xFFDC2626);
  static const redBg       = Color(0xFFFEE2E2);
  static const redBorder   = Color(0xFFFCA5A5);
  static const amber       = Color(0xFFD97706);
  static const amberBg     = Color(0xFFFEF3C7);
  static const amberBorder = Color(0xFFFCD34D);
}

// ─── Screen ────────────────────────────────────────────────────────────────────

class MarketingListScreen extends StatelessWidget {
  const MarketingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketingListViewModel>.reactive(
      viewModelBuilder: () => MarketingListViewModel(),
      onViewModelReady: (vm) => vm.fetchLeads(),
      builder: (context, vm, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: _C.bg,
            appBar: _buildAppBar(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MarketingFormScreen(Id: ''),
                  ),
                );
                if (result == true) vm.fetchLeads();
              },
              backgroundColor: _C.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                "Add merchandise",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            body: vm.isBusy
                ? const Center(
                child: CircularProgressIndicator(color: _C.primary))
                : vm.leads.isEmpty
                ? const _EmptyState()
                : RefreshIndicator(
              color: _C.primary,
              onRefresh: vm.fetchLeads,
              child: ListView.separated(
                padding:
                const EdgeInsets.fromLTRB(16, 10, 16, 100),
                itemCount: vm.leads.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lead = vm.leads[index];
                  return _MerchandiseCard(
                    customer:
                    lead.customer ?? "Unknown Customer",
                    workflowState: lead.workflowState,
                    date: lead.date ?? "—",
                    totalQty:
                    lead.totalQty?.toString() ?? "0",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MarketingFormScreen(
                              Id: lead.name ?? ""),
                        ),
                      );
                      if (result == true) vm.fetchLeads();
                    },
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MarketingFormScreen(
                              Id: lead.name ?? ""),
                        ),
                      );
                      if (result == true) vm.fetchLeads();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: const Text(
        "Merchandise",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Merchandise Card ──────────────────────────────────────────────────────────

class _MerchandiseCard extends StatelessWidget {
  final String customer;
  final String? workflowState;
  final String date;
  final String totalQty;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _MerchandiseCard({
    required this.customer,
    required this.workflowState,
    required this.date,
    required this.totalQty,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(14, 13, 8, 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEFF6FF)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _C.tint,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _C.borderLight),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: _C.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Customer name
                    Expanded(
                      child: Text(
                        customer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: _C.textHead,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status pill
                    _WorkflowPill(state: workflowState),
                    // Edit button
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: _C.tint,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _C.borderLight),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: _C.primary,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Meta row ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
                child: Row(
                  children: [
                    _MetaChip(
                      icon: Icons.calendar_today_outlined,
                      label: date,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.inventory_2_outlined,
                      label: "Qty: $totalQty",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Workflow Pill ─────────────────────────────────────────────────────────────

class _WorkflowPill extends StatelessWidget {
  final String? state;

  const _WorkflowPill({required this.state});

  @override
  Widget build(BuildContext context) {
    final label = (state == null || state!.trim().isEmpty)
        ? "Draft"
        : state!.trim();

    Color color;
    Color bg;
    Color border;

    switch (label) {
      case "Approved":
        color  = _C.green;
        bg     = _C.greenBg;
        border = _C.greenBorder;
        break;
      case "Rejected":
        color  = _C.red;
        bg     = _C.redBg;
        border = _C.redBorder;
        break;
      case "Pending":
        color  = _C.amber;
        bg     = _C.amberBg;
        border = _C.amberBorder;
        break;
      default:
        color  = _C.textMuted;
        bg     = _C.tint;
        border = _C.borderLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Meta Chip ─────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: _C.tint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _C.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _C.textMuted),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: _C.textHead,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding:
        const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _C.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.campaign_outlined,
                size: 38, color: _C.borderLight),
            SizedBox(height: 10),
            Text(
              "No merchandise found",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _C.textHead,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Tap \"Add merchandise\" to create a new entry",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: _C.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}