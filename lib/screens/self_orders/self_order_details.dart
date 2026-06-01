import 'package:flutter/material.dart';

import '../../router.router.dart';
import '../../services/add_order_services.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoading = true;
  dynamic orderData;
  final AddOrderServices _service = AddOrderServices();

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    try {
      final fetchedOrder = await _service.getOrder(widget.orderId);
      print("========== ITEMS ==========");
      for (var item in fetchedOrder?.items ?? []) {
        print("ITEM NAME = ${item.itemName}");
        print("QTY = ${item.qty}");
        print("AMOUNT = ${item.amount}");
        print("NET AMOUNT = ${item.netAmount}");
        print("BASE AMOUNT = ${item.baseAmount}");
        print("DELIVERY DATE = ${item.deliveryDate}");
      }
      print("===========================");
      setState(() {
        orderData = fetchedOrder;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = orderData?.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        actions: [
          if (orderData?.docstatus == 0)
            IconButton(
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.createSelfOrderScreen,
                arguments: CreateSelfOrderScreenArguments(orderId: widget.orderId),
              ),
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderData == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBanner(orderData),
            const SizedBox(height: 18),
            const _SectionTitle(
              icon: Icons.person_outline,
              title: "Customer & Warehouse",
              subtitle: "Order information",
            ),
            const SizedBox(height: 12),
            _CustomerWarehouseCard(orderData),
            const SizedBox(height: 18),
            const _SectionTitle(
              icon: Icons.receipt_long_outlined,
              title: "Order Summary",
              subtitle: "Totals & quantities",
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _HighlightCard(
                    title: "Total Items",
                    value: items.length.toString(),
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                // const SizedBox(width: 12),
                // Expanded(
                //   child: _HighlightCard(
                //     title: "Grand Total",
                //     value: "₹${orderData.grandTotal ?? 0}",
                //     icon: Icons.currency_rupee,
                //     color: const Color(0xFF059669),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 22),
            _SectionTitle(
              icon: Icons.shopping_cart_outlined,
              title: "Items",
              subtitle: "${items.length} item(s)",
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Center(child: Text("No items found"))
            else
              ...List.generate(
                items.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OrderItemCard(items[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Banner ───────────────────────────────────────────────────────────────

class _TopBanner extends StatelessWidget {
  final dynamic order;
  const _TopBanner(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(.85),
          ],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.name ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(order.customer ?? "-",
                    style: const TextStyle(color: Colors.white70)),
                Text("Order Date: ${order.transactionDate ?? "-"}",
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Customer & Warehouse Card ─────────────────────────────────────────────────

class _CustomerWarehouseCard extends StatelessWidget {
  final dynamic order;
  const _CustomerWarehouseCard(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.05))
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            label: "Customer",
            value: order.customer ?? "-",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: "Warehouse",
            value: order.setWarehouse ?? "-",
            icon: Icons.warehouse_outlined,
          ),
        ],
      ),
    );
  }
}

// ─── Order Item Card ───────────────────────────────────────────────────────────

class _OrderItemCard extends StatelessWidget {
  final dynamic item;
  const _OrderItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    final finalAmount =
        (item.amount ?? 0) +
            (item.igstAmount ?? 0) +
            (item.cgstAmount ?? 0) +
            (item.sgstAmount ?? 0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.04))
        ],
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF4F46E5),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // Item name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.deliveryDate ?? "-",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 12,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      finalAmount.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Qty badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 13, color: Color(0xFF4F46E5)),
                const SizedBox(width: 4),
                Text(
                  "Qty: ${item.qty ?? 0}",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F46E5),
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

// ─── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE8F0FE),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: textTheme.bodySmall
                      ?.copyWith(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Info Row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Highlight Card ────────────────────────────────────────────────────────────

class _HighlightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _HighlightCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(.14),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}