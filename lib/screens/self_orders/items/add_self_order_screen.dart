import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../constants.dart';
import '../../../model/add_order_model.dart';
import 'add_self_order_viewmodel.dart';

class CreateSelfOrderScreen extends StatelessWidget {
  final String orderId;

  const CreateSelfOrderScreen({
    super.key,
    this.orderId = "",
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateSelfOrderViewModel>.reactive(
      viewModelBuilder: () => CreateSelfOrderViewModel(),
      onViewModelReady: (vm) => vm.initialise(context, orderId),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          appBar: AppBar(
            elevation: 0,
            title: Text(model.isEdit ? "Edit Self Order" : "Create Self Order"),
          ),
          body: model.isBusy && !model.initialized
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: model.formKey,
                  child: Column(
                    children: [
                      _StepHeader(currentStep: model.currentStep),
                      Expanded(
                        child: model.currentStep == 0
                            ? _ItemsGridSection(model: model)
                            : _CheckoutSection(model: model),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: _BottomBar(model: model),
        );
      },
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int currentStep;

  const _StepHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          _stepCircle("1", currentStep == 0 || currentStep == 1),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.blue.shade300,
            ),
          ),
          _stepCircle("2", currentStep == 1),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              currentStep == 0 ? "Select Items" : "Checkout",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCircle(String text, bool active) {
    return Container(
      height: 32,
      width: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2563EB) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ItemsGridSection extends StatelessWidget {
  final CreateSelfOrderViewModel model;

  const _ItemsGridSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: _SectionTitle("Select Items")),
                  TextButton.icon(
                    onPressed: model.clearAllItems,
                    icon: const Icon(Icons.clear_all),
                    label: const Text("Clear Cart"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: model.searchController,
                onChanged: model.searchItems,
                decoration: _inputDecoration("Search item").copyWith(
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              if (model.filteredItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text("No items found"),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;

                    return GridView.builder(
                      itemCount: model.filteredItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.55, // 🔥 increase this
                      ),
                      itemBuilder: (context, index) {
                        final item = model.filteredItems[index];
                        return _GridItemCard(
                          item: item,
                          onAdd: () => model.addItem(item),
                          onRemove: () => model.removeItem(item),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  final CreateSelfOrderViewModel model;

  const _CheckoutSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: _SectionTitle("Cart Items")),
                  Text(
                    "${model.selectedItems.length} item(s)",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (model.selectedItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "No items selected",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
              else
                ...List.generate(
                  model.selectedItems.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartItemCard(
                      item: model.selectedItems[index],
                      index: index,
                      model: model,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),


        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle("Delivery"),
              const SizedBox(height: 14),

              TextFormField(
                controller: model.deliveryDateController,
                readOnly: true,
                onTap: () => model.selectDeliveryDate(context),
                decoration: _inputDecoration("Delivery date").copyWith(
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                validator: model.validateDeliveryDate,
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: model.descriptionController,
                maxLines: 3,
                decoration: _inputDecoration("Order Description").copyWith(
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 14),
        // _BillingSummaryCard(model: model),
        SelfBillingSection(model: model),
      ],
    );
  }
}

class _GridItemCard extends StatelessWidget {
  final Items item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _GridItemCard({
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final qty = (item.qty ?? 0).toInt();
    final inCart = qty > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.image != null && item.image!.isNotEmpty
                      ? '$baseurl${item.image}'
                      : '',
                  width: getWidth(context) / 5,
                  height: getHeight(context) / 13,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => Image.asset(
                    'assets/images/image.png',
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              item.itemName ?? item.itemCode ?? "-",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),

            Text(
              item.itemCode ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            //
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF4F7FF),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Text(
            //     "₹ ${(item.rate ?? 0).toStringAsFixed(2)}",
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //     style: const TextStyle(
            //       fontSize: 12.5,
            //       fontWeight: FontWeight.w700,
            //       color: Color(0xFF2563EB),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 8),

            if (!inCart)
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    elevation: 0,
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else ...[
              // Container(
              //   height: 38,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF7F8FC),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: const Color(0xFFE5E7EB)),
              //   ),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         onPressed: onRemove,
              //         icon: const Icon(Icons.remove, size: 18),
              //         splashRadius: 18,
              //         constraints: const BoxConstraints(),
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //       ),
              //       Expanded(
              //         child: Center(
              //           child: Text(
              //             qty.toString(),
              //             style: const TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //         onPressed: onAdd,
              //         icon: const Icon(Icons.add, size: 18),
              //         splashRadius: 18,
              //         constraints: const BoxConstraints(),
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  onPressed: onRemove,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Remove",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
class _CartItemCard extends StatelessWidget {
  final Items item;
  final int index;
  final CreateSelfOrderViewModel model;

  const _CartItemCard({
    required this.item,
    required this.index,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final qtyController = model.getQuantityController(index);

    return Container(
      padding: const EdgeInsets.all(8), // 🔻 reduced
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10), // 🔻 smaller radius
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 important
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.itemName ?? item.itemCode ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13, // 🔻 smaller
                  ),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => model.deleteItem(index),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18, // 🔻 smaller icon
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Expanded(
                child: Text(
                  item.itemCode ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11, // 🔻 smaller
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Text(
                "Qty:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 11),

              Expanded(
                child: SizedBox(
                  height: 42, // 🔥 control height
                  child: TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 12),
                    decoration: _inputDecoration("Qty").copyWith(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6, // 🔻 tighter field
                      ),
                    ),
                    onChanged: (v) {
                      model.setItemQuantity(index, int.tryParse(v) ?? 0);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 51),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingSummaryCard extends StatelessWidget {
  final CreateSelfOrderViewModel model;

  const _BillingSummaryCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final order = model.orderData;

    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle("Billing Summary"),
          const SizedBox(height: 14),
          _SummaryRow(
            title: "Net Total",
            value: "₹ ${((order.netTotal ?? 0) as num).toStringAsFixed(2)}",
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            title: "Taxes & Charges",
            value:
                "₹ ${((order.totalTaxesAndCharges ?? 0) as num).toStringAsFixed(2)}",
          ),
          const Divider(height: 20),
          _SummaryRow(
            title: "Grand Total",
            value: "₹ ${((order.grandTotal ?? 0) as num).toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final CreateSelfOrderViewModel model;

  const _BottomBar({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: model.currentStep == 0
            ? _itemsStep(context)
            : _checkoutStep(context),
      ),
    );
  }

  Widget _itemsStep(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${model.totalItemsCount} qty • ${model.selectedItems.length} item(s)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        /// Checkout Button
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_rounded,
                size: 20, color: Colors.white),
            label: const Text(
              "Checkout",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            onPressed: model.canGoCheckout ? model.goToCheckout : null,
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: model.canGoCheckout
                  ? const Color(0xFF2563EB)
                  : Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkoutStep(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text("Back"),
            onPressed: model.isBusy ? null : model.goBackToItems,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Place Order Button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed:
                model.isBusy ? null : () => model.onSubmitPressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: model.isBusy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "Place Order",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF2563EB)),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isBold ? 15 : 14,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      children: [
        Text(title, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}

class SelfBillingSection extends StatelessWidget {
  final CreateSelfOrderViewModel model;

  const SelfBillingSection({required this.model});

  String _money(num? v) => (v ?? 0).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final order = model.orderData;

    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle("Billing Summary"),
          const SizedBox(height: 14),

          // _SummaryRow(
          //   title: "Subtotal",
          //   value: "₹${_money(order.netTotal)}",
          // ),
          //
          // const SizedBox(height: 8),
          //
          // _SummaryRow(
          //   title: "Total Tax",
          //   value: "₹${_money(order.totalTaxesAndCharges)}",
          // ),
          //
          // const Divider(height: 20),

          _SummaryRow(
            title: "Total",
            value: "₹${_money(order.grandTotal)}",
            isBold: true,
          ),
        ],
      ),
    );
  }
}