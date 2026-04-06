import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import 'stock_viewmodel.dart';

// ─── AppColors (import from your shared file or paste here) ───────────────────

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

class ItemStockScreen extends StatelessWidget {
  const ItemStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ItemStockViewModel>.reactive(
      viewModelBuilder: () => ItemStockViewModel(),
      onViewModelReady: (model) => model.fetchStock(),
      builder: (context, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            body: RefreshIndicator(
              color: _C.primary,
              onRefresh: () async => model.fetchStock(),
              child: fullScreenLoader(
                context: context,
                loader: model.isBusy,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ── App Bar ──
                    SliverAppBar(
                      pinned: true,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      centerTitle: true,
                      title: const Text(
                        "Item stock",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _C.textHead,
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(106),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Column(
                            children: [
                              // Search field
                              Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _C.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _C.border),
                                ),
                                child: TextField(
                                  onChanged: model.updateSearch,
                                  textInputAction: TextInputAction.search,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _C.textHead,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "Search by item name or code",
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: _C.textMuted,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: _C.textMuted,
                                      size: 18,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Summary + filter row
                              Row(
                                children: [
                                  Expanded(
                                    child: _SummaryPill(
                                      icon: Icons.inventory_2_outlined,
                                      label: "Items",
                                      value: model.filteredItems.length
                                          .toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _FilterButton(
                                      label: model.selectedWarehouse ??
                                          "Warehouse",
                                      onTap: () => _showWarehouseSheet(
                                        context: context,
                                        model: model,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Content ──
                    if (model.filteredItems.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyInventory(
                            warehouse: model.selectedWarehouse),
                      )
                    else
                      SliverPadding(
                        padding:
                        const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        sliver: SliverList.separated(
                          itemCount: model.filteredItems.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            return _InventoryCard(
                                item: model.filteredItems[i]);
                          },
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

  void _showWarehouseSheet({
    required BuildContext context,
    required ItemStockViewModel model,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const Text(
                "Select warehouse",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _C.textHead,
                ),
              ),
              const SizedBox(height: 10),
              ...model.warehouses.map((w) {
                final selected = model.selectedWarehouse == w;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: selected ? _C.tint : _C.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 2),
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.warehouse_outlined,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      w,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_circle_rounded,
                        color: _C.primary, size: 18)
                        : null,
                    onTap: () {
                      model.updateWarehouse(w);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ─── Summary Pill ──────────────────────────────────────────────────────────────

class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _C.primary),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Button ─────────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.warehouse_outlined,
                size: 16, color: _C.primary),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: _C.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Inventory Card ────────────────────────────────────────────────────────────

class _InventoryCard extends StatelessWidget {
  final dynamic item;

  const _InventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String name = item.itemName ?? '';
    final String code = item.itemCode ?? '';
    final String wh   = item.warehouse ?? '';
    final double qty  = (item.actualQty as num?)?.toDouble() ?? 0;

    Color qtyColor;
    Color qtyBg;
    Color qtyBorder;
    String qtyLabel;

    if (qty <= 0) {
      qtyColor  = _C.red;
      qtyBg     = _C.redBg;
      qtyBorder = _C.redBorder;
      qtyLabel  = "Out of stock";
    } else if (qty < 5) {
      qtyColor  = _C.amber;
      qtyBg     = _C.amberBg;
      qtyBorder = _C.amberBorder;
      qtyLabel  = "Low stock";
    } else {
      qtyColor  = _C.green;
      qtyBg     = _C.greenBg;
      qtyBorder = _C.greenBorder;
      qtyLabel  = "In stock";
    }

    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Item icon ──
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _C.tint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.borderLight),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: _C.primary,
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + code + warehouse ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.warehouse_outlined,
                          size: 12, color: _C.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          wh,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: _C.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Qty badge ──
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: qtyBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: qtyBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    qty.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: qtyColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    qtyLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: qtyColor.withOpacity(0.75),
                    ),
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

// ─── Empty State ───────────────────────────────────────────────────────────────

class _EmptyInventory extends StatelessWidget {
  final String? warehouse;

  const _EmptyInventory({this.warehouse});

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
            const Icon(Icons.inventory_2_outlined,
                size: 38, color: _C.borderLight),
            const SizedBox(height: 10),
            const Text(
              "No stock found",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _C.textHead,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              warehouse == null
                  ? "Try changing warehouse or search"
                  : "No items in \"$warehouse\"",
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

// ─── Model ─────────────────────────────────────────────────────────────────────

class ItemStock {
  final String itemCode;
  final String itemName;
  final double actualQty;
  final String warehouse;

  ItemStock({
    required this.itemCode,
    required this.itemName,
    required this.actualQty,
    required this.warehouse,
  });

  factory ItemStock.fromJson(Map<String, dynamic> json) {
    return ItemStock(
      itemCode:  json['item_code'] ?? '',
      itemName:  json['item_name'] ?? '',
      actualQty: (json['actual_qty'] ?? 0).toDouble(),
      warehouse: json['warehouse'] ?? '',
    );
  }
}