import 'package:flutter/material.dart';
import 'package:geolocation/screens/tour_forms/list_tour/list_tour_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../model/tour_model.dart';
import '../../../widgets/full_screen_loader.dart';
import '../add_tour/add_tour.dart';

class ListTourScreen extends StatelessWidget {
  const ListTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListTourViewModel>.reactive(
      viewModelBuilder: () => ListTourViewModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: const Text('My Tours'),
          centerTitle: true,
        ),
        body: fullScreenLoader(
          loader: model.isBusy,
          context: context,
          child: RefreshIndicator(
            onRefresh: () => model.refresh(context),
            child: model.visitList.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: model.visitList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final Tour visit = model.visitList[index];
                      return _VisitCard(
                        visit: visit,
                        model: model,
                      );
                    },
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Create Tour'),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateTourScreen(),
              ),
            );

            if (result == true) {
              model.refresh(context);
            }
          },
        ),
      ),
    );
  }
}
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

class _VisitCard extends StatelessWidget {
  final Tour visit;
  final ListTourViewModel model;

  const _VisitCard({
    required this.visit,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                // Location icon box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _C.tint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.borderLight),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: _C.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                // Area name
                Expanded(
                  child: Text(
                    visit.area ?? "—",
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
                // Calls badge
                _CallsBadge(count: visit.totalCalls ?? 0),
                const SizedBox(width: 4),
                // Delete button
                GestureDetector(
                  onTap: model.isBusy
                      ? null
                      : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          "Delete tour?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _C.textHead,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to delete this tour?",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _C.textMuted,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text(
                              "Cancel",
                              style:
                              TextStyle(color: _C.textMuted),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: _C.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      model.deleteTour(visit.name, context);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _C.redBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _C.redBorder),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: _C.red,
                      size: 15,
                    ),
                  ),
                ),
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
                  icon: Icons.calendar_today_outlined,
                  text: visit.date ?? "—",
                ),
                if ((visit.description ?? "").isNotEmpty) ...[
                  const SizedBox(height: 7),
                  _MetaRow(
                    icon: Icons.notes_outlined,
                    text: visit.description!,
                    maxLines: 2,
                  ),
                ],
                const SizedBox(height: 7),
                _MetaRow(
                  icon: Icons.person_outline_rounded,
                  text: visit.owner ?? "—",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Calls Badge ───────────────────────────────────────────────────────────────

class _CallsBadge extends StatelessWidget {
  final int count;

  const _CallsBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _C.tint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _C.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.call_outlined,
            size: 12,
            color: _C.primary,
          ),
          const SizedBox(width: 5),
          Text(
            "$count call${count == 1 ? '' : 's'}",
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: _C.primary,
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
            Icon(Icons.map_outlined, size: 38, color: _C.borderLight),
            SizedBox(height: 10),
            Text(
              "No tours found",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _C.textHead,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Create a tour to get started",
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