import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';

import 'holiday_viewmodel.dart';
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
  static const amber       = Color(0xFFD97706);
  static const amberBg     = Color(0xFFFEF3C7);
  static const amberBorder = Color(0xFFFCD34D);
}

class HolidayScreen extends StatelessWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ViewModelBuilder<Holidayviewmodel>.reactive(
      viewModelBuilder: () => Holidayviewmodel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Holiday'),
          // backgroundColor: cs.surface,
          // surfaceTintColor: cs.surface,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: DropdownButtonFormField<int>(
                initialValue: model.selectedYear,
                onChanged: model.updateSelectedYear,
                isDense: true,
                decoration: InputDecoration(
                  labelText: "Year",
                  filled: true,
                  fillColor: const Color(0xFFF6F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: model.availableYears
                    .map(
                      (year) => DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        body: fullScreenLoader(
          loader: model.isBusy,
          context: context,
          child:  Column(
            children: [

              // ── Count bar ──
              if (model.holidaylist.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: _C.tint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _C.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.beach_access_outlined,
                            size: 15, color: _C.primary),
                        const SizedBox(width: 7),
                        Text(
                          "${model.holidaylist.length} holiday${model.holidaylist.length == 1 ? '' : 's'} in ${model.selectedYear}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _C.textHead,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── List ──
              Expanded(
                child: fullScreenLoader(
                  loader: model.isBusy,
                  context: context,
                  child: model.holidaylist.isEmpty
                      ? _EmptyState(year: model.selectedYear)
                      : ListView.separated(
                    padding:
                    const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: model.holidaylist.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final h = model.holidaylist[index];
                      return _HolidayCard(holiday: h);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─── Holiday Card ──────────────────────────────────────────────────────────────

class _HolidayCard extends StatelessWidget {
  final dynamic holiday;

  const _HolidayCard({required this.holiday});

  // Simple colour rotation so consecutive cards feel distinct
  _CardAccent _accent(int index) {
    final accents = [
      _CardAccent(_C.primary, _C.tint, _C.borderLight),
      _CardAccent(_C.green, _C.greenBg, _C.greenBorder),
      _CardAccent(_C.amber, _C.amberBg, _C.amberBorder),
    ];
    return accents[index % accents.length];
  }

  @override
  Widget build(BuildContext context) {
    // Parse a rough index from the date string for colour selection
    final raw = holiday.date ?? "";
    int idx = 0;
    try {
      idx = DateTime.parse(raw).month;
    } catch (_) {}

    final accent = _accent(idx);

    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Icon box ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.bg,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: accent.border),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/beach-chair.png',
                width: 20,
                height: 20,
                color: accent.color,
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + day ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    holiday.description ?? "—",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _C.textHead,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    holiday.day ?? "—",
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: _C.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Date pill ──
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accent.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accent.border),
              ),
              child: Text(
                holiday.date ?? "—",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: accent.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardAccent {
  final Color color;
  final Color bg;
  final Color border;
  const _CardAccent(this.color, this.bg, this.border);
}

// ─── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final int? year;

  const _EmptyState({this.year});

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
          children: [
            const Icon(Icons.beach_access_outlined,
                size: 38, color: _C.borderLight),
            const SizedBox(height: 10),
            const Text(
              "No holidays found",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _C.textHead,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              year != null
                  ? "No holidays available for $year"
                  : "Try selecting a different year",
              textAlign: TextAlign.center,
              style: const TextStyle(
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