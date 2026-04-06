import 'package:flutter/material.dart';
import 'package:geolocation/screens/lead_screen/lead_list/lead_viewmodel.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../router.router.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeadListViewModel>.reactive(
      viewModelBuilder: LeadListViewModel.new,
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,

          /// APP BAR
          appBar: AppBar(
            title: const Text('Leads'),
            centerTitle: true,
            elevation: 0,
          ),

          /// BODY
          body: fullScreenLoader(
            context: context,
            loader: model.isBusy,
            child: Column(
              children: [
                /// 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: TextField(
                    controller: _searchController,
                    onChanged: model.filterBySearch,
                    decoration: InputDecoration(
                      hintText: "Search by company...",
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// 📋 LEAD LIST
                Expanded(
                  child: model.filterleadlist.isEmpty
                      ? const _EmptyState()
                      : RefreshIndicator(
                          onRefresh: model.refresh,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 90),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: model.filterleadlist.length,
                            itemBuilder: (context, index) {
                              final lead = model.filterleadlist[index];

                              return InkWell(
                                onTap: () => model.onRowClick(context, lead),
                                child: LeadCard(
                                  user: lead.leadOwner ?? '',
                                  status: lead.status ?? '',
                                  name: lead.name ?? '',
                                  company: lead.companyName ?? '',
                                  region: lead.territory ?? 'N/A',
                                  location: lead.customLocationAddress ??
                                      'Location not available',
                                  date: lead.creation ?? '',
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),

          /// ➕ CREATE LEAD
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text('Create Lead'),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addLeadScreen,
                arguments: const AddLeadScreenArguments(leadId: ''),
              );
              if (result == true) model.refresh();
            },
          ),
        );
      },
    );
  }
}

/// =======================
/// LEAD CARD
/// =======================
// ─── Theme Constants ───────────────────────────────────────────────────────────

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
  static const indigo      = Color(0xFF4F46E5);
  static const indigoBg    = Color(0xFFEEF2FF);
  static const indigoBorder= Color(0xFFC7D2FE);
}

// ─── Lead Card ─────────────────────────────────────────────────────────────────

class LeadCard extends StatelessWidget {
  final String user;
  final String status;
  final String name;
  final String company;
  final String region;
  final String location;
  final String date;

  const LeadCard({
    super.key,
    required this.user,
    required this.status,
    required this.name,
    required this.company,
    required this.region,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    try {
      formattedDate = DateFormat('dd MMM yyyy · hh:mm a')
          .format(DateTime.parse(date));
    } catch (_) {
      formattedDate = date;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEFF6FF)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Company initials avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.tint,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: _C.borderLight),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    company.isNotEmpty
                        ? company[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _C.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: _C.textHead,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _C.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: status),
              ],
            ),
          ),

          // ── Meta info ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MetaRow(
                  icon: Icons.public_outlined,
                  text: region,
                ),
                const SizedBox(height: 7),
                _MetaRow(
                  icon: Icons.location_on_outlined,
                  text: location,
                  maxLines: 2,
                ),
                const SizedBox(height: 7),
                _MetaRow(
                  icon: Icons.person_outline_rounded,
                  text: user,
                ),
              ],
            ),
          ),

          // ── Footer: date ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 9),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFF),
              border: Border(
                top: BorderSide(color: Color(0xFFEFF6FF)),
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: _C.textMuted),
                const SizedBox(width: 5),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: _C.textMuted,
                    fontWeight: FontWeight.w500,
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

// ─── Meta Row ──────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final int maxLines;

  const _MetaRow({
    required this.icon,
    required this.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: _C.textMuted),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              color: _C.textHead,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Status Badge ──────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  _StatusStyle _style(String status) {
    switch (status) {
      case "Converted":
        return _StatusStyle(
          color: _C.green,
          bg: _C.greenBg,
          border: _C.greenBorder,
          dot: _C.green,
        );
      case "Interested":
        return _StatusStyle(
          color: _C.amber,
          bg: _C.amberBg,
          border: _C.amberBorder,
          dot: _C.amber,
        );
      case "Lead":
        return _StatusStyle(
          color: _C.primary,
          bg: _C.tint,
          border: _C.borderLight,
          dot: _C.primary,
        );
      case "Opportunity":
        return _StatusStyle(
          color: _C.indigo,
          bg: _C.indigoBg,
          border: _C.indigoBorder,
          dot: _C.indigo,
        );
      case "Lost Quotation":
        return _StatusStyle(
          color: _C.red,
          bg: _C.redBg,
          border: _C.redBorder,
          dot: _C.red,
        );
      default:
        return _StatusStyle(
          color: const Color(0xFF64748B),
          bg: const Color(0xFFF1F5F9),
          border: const Color(0xFFCBD5E1),
          dot: const Color(0xFF64748B),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: s.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: s.dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: s.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  final Color color;
  final Color bg;
  final Color border;
  final Color dot;

  const _StatusStyle({
    required this.color,
    required this.bg,
    required this.border,
    required this.dot,
  });
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
            Icon(Icons.inbox_outlined,
                size: 38, color: _C.borderLight),
            SizedBox(height: 10),
            Text(
              "No leads available",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _C.textHead,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Try adjusting your filters",
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