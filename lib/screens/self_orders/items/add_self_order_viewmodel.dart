import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

import '../../../model/add_order_model.dart';
import '../../../model/order_details_model.dart';
import '../../../services/add_order_services.dart';

class CreateSelfOrderViewModel extends BaseViewModel {
  final _logger = Logger();
  final _service = AddOrderServices();

  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final deliveryDateController = TextEditingController();
  final descriptionController = TextEditingController();

  final Map<int, TextEditingController> _quantityControllers = {};
  final Map<int, TextEditingController> _rateControllers = {};

  Timer? _debounce;
  Timer? _searchDebounce;

  bool initialized = false;
  bool isEdit = false;
  bool isSame = false;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  String orderId = "";
  String name = "";
  DateTime? selectedDeliveryDate;

  List<Items> allItems = [];
  List<Items> filteredItems = [];
  List<Items> selectedItems = [];
  List<OrderDetailsModel> orderDetails = [];

  AddOrderModel orderData = AddOrderModel();

  int orderStatus = 0;

  Future<void> initialise(BuildContext context, String orderId) async {
    setBusy(true);
    this.orderId = orderId;
    orderStatus = 0;

    try {
      allItems = await _service.fetchSelfItems();
      filteredItems = List.of(allItems);

      if (orderId.isNotEmpty) {
        isEdit = true;
        final fetchedOrder = await _service.getOrder(orderId);
        if (fetchedOrder != null) {
          orderData = fetchedOrder;
          deliveryDateController.text = orderData.deliveryDate ?? "";

          if ((orderData.deliveryDate ?? "").isNotEmpty) {
            try {
              selectedDeliveryDate =
                  DateFormat('yyyy-MM-dd').parse(orderData.deliveryDate!);
            } catch (_) {}
          }

          selectedItems = List<Items>.from(orderData.items ?? []);
          print(selectedItems.toString());
          orderStatus = orderData.docstatus ?? 0;
          isSame = true;

          _syncSelectedItemsIntoAllItems();
        }
      }

      updateTextFieldValue();
      initialized = true;
    } catch (e) {
      _showToast("Initialization failed", isError: true);
      _logger.e(e);
    }

    setBusy(false);
    notifyListeners();
  }

  void _syncSelectedItemsIntoAllItems() {
    for (final selected in selectedItems) {
      final index = allItems.indexWhere((e) => e.itemCode == selected.itemCode);
      if (index != -1) {
        allItems[index] = selected;
      }
    }
    filteredItems = List.of(allItems);
  }

  int get totalItemsCount =>
      selectedItems.fold<int>(0, (sum, item) => sum + ((item.qty ?? 0).toInt()));

  bool get canGoCheckout => selectedItems.isNotEmpty;

  bool get canSubmitOrder =>
      selectedItems.isNotEmpty && deliveryDateController.text.trim().isNotEmpty;

  void goToCheckout() {
    if (!canGoCheckout) return;
    _currentStep = 1;
    _refreshControllers();
    notifyListeners();
  }

  void goBackToItems() {
    _currentStep = 0;
    notifyListeners();
  }

  void searchItems(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      final lower = query.trim().toLowerCase();
      filteredItems = lower.isEmpty
          ? List.of(allItems)
          : allItems.where((item) {
        final itemName = (item.itemName ?? "").toLowerCase();
        final itemCode = (item.itemCode ?? "").toLowerCase();
        return itemName.contains(lower) || itemCode.contains(lower);
      }).toList();
      notifyListeners();
    });
  }

  void addItem(Items item) {
    isSame = false;

    final currentQty = item.qty ?? 0;
    item.qty = currentQty + 1;
    item.deliveryDate = orderData.deliveryDate;

    final index = selectedItems.indexWhere((e) => e.itemCode == item.itemCode);

    if (index == -1) {
      selectedItems.add(item);
    } else {
      selectedItems[index] = item;
    }

    _recalculateAllItems();
    orderData.items = selectedItems;
    updateTextFieldValue();
    _refreshControllers();
    _debouncedUpdate();
    notifyListeners();
    print(selectedItems.toString());
  }

  void removeItem(Items item) {
    isSame = false;

    final currentQty = item.qty ?? 0;

    if (currentQty > 1) {
      item.qty = currentQty - 1;

      final index =
      selectedItems.indexWhere((e) => e.itemCode == item.itemCode);
      if (index != -1) {
        selectedItems[index] = item;
      }
    } else {
      item.qty = 0;
      selectedItems.removeWhere((e) => e.itemCode == item.itemCode);
    }

    _recalculateAllItems();
    orderData.items = selectedItems;
    updateTextFieldValue();
    _refreshControllers();
    _debouncedUpdate();
    notifyListeners();
    print(selectedItems.toString());
  }

  void clearAllItems() {
    isSame = false;

    for (final item in allItems) {
      item.qty = 0;
      item.amount = 0;
      item.netAmount = 0;
      item.netRate = 0;
      item.discountPercentage = 0;
      item.discountAmount = 0;
      item.distributedDiscountAmount = 0;
    }

    selectedItems.clear();
    orderData.items = [];
    _clearControllers();
    updateTextFieldValue();
    _recalculateAllItems();
    _debouncedUpdate();
    notifyListeners();
  }

  Future<void> selectDeliveryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDeliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDeliveryDate = picked;
      deliveryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      orderData.deliveryDate = deliveryDateController.text;

      for (final item in selectedItems) {
        item.deliveryDate = orderData.deliveryDate;
      }

      isSame = false;
      _debouncedUpdate();
      notifyListeners();
    }
  }

  void updateTextFieldValue() {
    displayString = selectedItems.isEmpty
        ? 'Items are not selected'
        : '${selectedItems.length} items selected';
  }

  String displayString = '';

  Future<void> onSubmitPressed(BuildContext context) async {
    if (_isSubmitted()) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedItems.isEmpty) {
      _showToast("Please select items first", isError: true);

    print("📦 SELF ORDER DATA: ${orderData.toJson()}");

      return;
    }

    setBusy(true);
    print(selectedItems.toString());
    orderData
      ..items = selectedItems
      ..deliveryDate = deliveryDateController.text.trim()
      ..description = descriptionController.text.trim();
    print("🧠 DESCRIPTION VALUE: ${descriptionController.text}");
    print("📦 FINAL SELF ORDER DATA: ${orderData.toJson()}");

    try {
      bool res;
print(orderData.items);
      if (isEdit) {
        res = await _service.addSelfOrder(orderData);
      } else {
        res = await _service.addSelfOrder(orderData);
      }

      if (res && context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _logger.e(e);
      _showToast("Failed to submit order", isError: true);
    }

    setBusy(false);
  }

  void _updateOrderDetails(List<OrderDetailsModel> details) {
    if (details.isEmpty) return;
    final d = details.first;
    orderData
      ..totalTaxesAndCharges = d.totalTaxesAndCharges
      ..grandTotal = d.grandTotal
      ..discountAmount = d.discountAmount
      ..total = d.netTotal
      ..netTotal = d.netTotal;
  }

  void _recalculateAllItems() {
    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      final qty = item.qty ?? 0;
      final rate = item.rate ?? 0;
      final gross = qty * rate;

      item
        ..amount = gross
        ..discountAmount = 0
        ..distributedDiscountAmount = 0
        ..netAmount = gross
        ..netRate = qty == 0 ? 0 : gross / qty
        ..discountPercentage = 0;
    }
  }

  void _debouncedUpdate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        orderData.items = selectedItems;

        if (selectedItems.isEmpty) {
          _updateOrderDetails([]);
          notifyListeners();
          return;
        }

        orderDetails = await _service.selfOrderDetails(orderData);
        _updateOrderDetails(orderDetails);
        notifyListeners();
      } catch (e) {
        _logger.e(e);
        _showToast("Failed to update order details", isError: true);
      }
    });
  }

  TextEditingController getQuantityController(int index) {
    if (!_quantityControllers.containsKey(index)) {
      final item = selectedItems[index];
      _quantityControllers[index] = TextEditingController(
        text: (item.qty?.toInt() ?? 0).toString(),
      );
    }
    return _quantityControllers[index]!;
  }

  TextEditingController getRateController(int index) {
    if (!_rateControllers.containsKey(index)) {
      final item = selectedItems[index];
      _rateControllers[index] = TextEditingController(
        text: item.rate?.toStringAsFixed(2) ?? "0.00",
      );
    }
    return _rateControllers[index]!;
  }

  void setItemQuantity(int index, int newQty) {
    isSame = false;

    if (newQty < 0) newQty = 0;

    final item = selectedItems[index];
    item.qty = newQty.toDouble();

    final allIndex = allItems.indexWhere((e) => e.itemCode == item.itemCode);
    if (allIndex != -1) {
      allItems[allIndex].qty = item.qty;
    }


    _quantityControllers[index]?.text = newQty.toString();

    _recalculateAllItems();
    orderData.items = selectedItems;
    updateTextFieldValue();
    _debouncedUpdate();
    notifyListeners();
  }

  void setItemRate(int index, double rate) {
    isSame = false;

    if (rate < 0) rate = 0;

    final item = selectedItems[index];
    item.rate = rate;

    final allIndex = allItems.indexWhere((e) => e.itemCode == item.itemCode);
    if (allIndex != -1) {
      allItems[allIndex].rate = rate;
    }

    _rateControllers[index]?.text = rate.toStringAsFixed(2);

    _recalculateAllItems();
    orderData.items = selectedItems;
    _debouncedUpdate();
    notifyListeners();
  }

  void deleteItem(int index) {
    isSame = false;

    final item = selectedItems[index];

    final allIndex = allItems.indexWhere((e) => e.itemCode == item.itemCode);
    if (allIndex != -1) {
      allItems[allIndex].qty = 0;
      allItems[allIndex].amount = 0;
      allItems[allIndex].netAmount = 0;
      allItems[allIndex].netRate = 0;
      allItems[allIndex].discountPercentage = 0;
      allItems[allIndex].discountAmount = 0;
      allItems[allIndex].distributedDiscountAmount = 0;
    }

    selectedItems.removeAt(index);

    _refreshControllers();
    orderData.items = selectedItems;
    updateTextFieldValue();
    _recalculateAllItems();
    _debouncedUpdate();
    notifyListeners();
  }

  void _refreshControllers() {
    _clearControllers();

    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];

      _quantityControllers[i] = TextEditingController(
        text: (item.qty?.toInt() ?? 0).toString(),
      );

      _rateControllers[i] = TextEditingController(
        text: item.rate?.toStringAsFixed(2) ?? "0.00",
      );
    }
  }

  void _clearControllers() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    for (final c in _rateControllers.values) {
      c.dispose();
    }

    _quantityControllers.clear();
    _rateControllers.clear();
  }

  String? validateDeliveryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select delivery date';
    }
    return null;
  }

  bool _isSubmitted() {
    if (orderStatus == 1) {
      _showToast('This document is already submitted.', isError: true);
      return true;
    }
    return false;
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchDebounce?.cancel();

    searchController.dispose();
    deliveryDateController.dispose();
    descriptionController.dispose();
    _clearControllers();

    super.dispose();
  }
}