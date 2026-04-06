import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../constants.dart';
import '../model/add_order_model.dart';
import '../model/order_details_model.dart';
import '../model/search_order_model.dart';

class AddOrderServices {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<List<String>> fetchCustomer() async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_customer_list',
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      final List<dynamic> dataList = response.data["message"];
      return dataList.map((e) => e.toString()).toList();
    } catch (e) {
      _handleError(e, "Unable to fetch customers");
      return [];
    }
  }

  Future<List<SearchCustomerList>> fetchCustomerDetails() async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_customer_list',
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      return List<SearchCustomerList>.from(
        response.data["data"].map((e) => SearchCustomerList.fromJson(e)),
      );
    } catch (e) {
      _handleError(e, "Unable to fetch customer details");
      return [];
    }
  }

  Future<List<String>> fetchWarehouse() async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_warehouselist',
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      final List<dynamic> dataList = response.data["data"];
      return dataList.map((e) => e["name"].toString()).toList();
    } catch (e) {
      _handleError(e, "Unable to fetch warehouses");
      return [];
    }
  }

  Future<List<Items>> fetchSelfItems() async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_self_order_item_list',
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      return List<Items>.from(
        response.data["data"].map((e) => Items.fromJson(e)),
      );
    } catch (e) {
      _handleError(e, "Unable to fetch items");
      return [];
    }
  }

  Future<List<Items>> fetchItems(String? warehouse) async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_item_list?warehouse=$warehouse',
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      return List<Items>.from(
        response.data["message"].map((e) => Items.fromJson(e)),
      );
    } catch (e) {
      _handleError(e, "Unable to fetch items");
      return [];
    }
  }

  Future<AddOrderModel?> getOrder(String id) async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/resource/Sales Order/$id',
        options: Options(headers: {'Authorization': await getTocken()}),
      );
      return AddOrderModel.fromJson(response.data["data"]);
    } catch (e) {
      _handleError(e, "Error while fetching order");
      return null;
    }
  }

  Future<Masters?> masters() async {
    baseurl = await geturl();
    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.masters',
        options: Options(headers: {'Authorization': await getTocken()}),
      );
      return Masters.fromJson(response.data["data"]);
    } catch (e) {
      _handleError(e, "Error while fetching masters");
      return null;
    }
  }

  Future<String> addOrder(AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      print("📦 ORDER DATA: ${json.encode(orderDetails)}");
      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.create_order',
        data: json.encode(orderDetails),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      Fluttertoast.showToast(msg: response.data['message'].toString());
      orderStatus = response.data["data"]['docstatus'];
      return response.data["data"]['name'].toString();
    } catch (e) {
      _handleError(e, "Failed to create order");
      return "";
    }
  }
  Future<bool> addSelfOrder(AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.create_self_order',
        data: orderDetails.toJson(),
        options: Options(headers: {'Authorization': await getTocken()}),
      );
      return true;
    } catch (e) {
      _handleError(e, "Failed to create order");
      return false;
    }
  }

  Future<bool> addDeliveryNote(Map orderDetails) async {
    baseurl = await geturl();
    try {
      print("📦 Sending Order: ${json.encode(orderDetails)}");

      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.create_delivery_note',
        data: orderDetails, // let Dio encode JSON
        options: Options(headers: {
          'Authorization': await getTocken(),
          'Content-Type': 'application/json',
        }),
      );

      print("✅ Response: ${response.data}");

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print("❌ DioError: ${e.response?.statusCode} - ${e.response?.data}");
      }
      _handleError(e, "Failed to create order");
      return false;
    }
  }

  Future<bool> updateOrder(AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      _logger.i(orderDetails.toJson());
      final response = await _dio.put(
        '$baseurl/api/resource/Sales Order/${orderDetails.name}',
        data: orderDetails.toJson(),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      orderStatus = response.data["data"]['docstatus'];
      Fluttertoast.showToast(msg: "Order updated successfully");
      return true;
    } catch (e) {
      _handleError(e, "Failed to update order");
      return false;
    }
  }

  Future<bool> cancelOrder(AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      final response = await _dio.put(
        '$baseurl/api/resource/Sales Order/${orderDetails.name}',
        data: orderDetails.toJson(),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      orderStatus = response.data["data"]['docstatus'];
      Fluttertoast.showToast(msg: "Order cancelled successfully");
      return true;
    } catch (e) {
      _handleError(e, "Failed to cancel order");
      return false;
    }
  }

  Future<bool> closeOrder(String? name) async {
    baseurl = await geturl();

    try {
      final response = await _dio.put(
        '$baseurl/api/method/erpnext.selling.doctype.sales_order.sales_order.update_status',
        data: json.encode({"name": name, "status": "Closed"}),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e, "Failed to close order");
      return false;
    }
  }

  Future<bool> reOpenOrder(String? name) async {
    baseurl = await geturl();

    try {
      final response = await _dio.put(
        '$baseurl/api/method/erpnext.selling.doctype.sales_order.sales_order.update_status',
        data: json.encode({"name": name, "status": "Draft"}),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e, "Failed to close order");
      return false;
    }
  }


  Future<List<OrderDetailsModel>> orderDetails(
      AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.prepare_order_totals',
        data: json.encode(orderDetails),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      return List<OrderDetailsModel>.from(
        response.data["data"].map((e) => OrderDetailsModel.fromJson(e)),
      );
    } catch (e) {
      _handleError(e, "Unable to prepare order details");
      return [];
    }
  }
  Future<List<OrderDetailsModel>> selfOrderDetails(
      AddOrderModel orderDetails) async {
    baseurl = await geturl();
    try {
      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.prepare_selforder_totals',
        data: json.encode(orderDetails),
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      return List<OrderDetailsModel>.from(
        response.data["data"].map((e) => OrderDetailsModel.fromJson(e)),
      );
    } on DioException catch (e) {
      _handleError(e, "Unable to prepare order details");
      return [];
    }
  }

  void _handleError(dynamic error, String fallbackMessage) {
    if (error is DioException) {
      final message = error.response?.data ??
          error.response?.data["message"] ??
          fallbackMessage;

      Fluttertoast.showToast(
        msg: "Error: ${message.toString()}",
        backgroundColor: const Color(0xFFBA1A1A),
        textColor: const Color(0xFFFFFFFF),
        gravity: ToastGravity.BOTTOM,
      );

      _logger.e("DioException: $message");
    } else {
      Fluttertoast.showToast(
        msg: fallbackMessage,
        backgroundColor: const Color(0xFFBA1A1A),
        textColor: const Color(0xFFFFFFFF),
      );
      _logger.e(error);
    }
  }
}
