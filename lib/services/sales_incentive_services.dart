import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../model/sales_incentive_model.dart';

class SalesIncentiveServices {

  Future<SalesIncentiveResponse?> fetchSalesIncentive(String period) async {
    baseurl = await geturl();

    try {
      var dio = Dio();

      var response = await dio.request(
        '$baseurl/api/method/mobile.mobile_env.app.get_sales_incentive_data?period=$period',
        options: Options(
          method: 'GET',
          headers: {'Authorization': await getTocken()},
        ),
      );

      if (response.statusCode == 200) {

        Map<String, dynamic> jsonData =
        json.decode(json.encode(response.data));

        // 🔥 IMPORTANT (your backend uses gen_response)
        var data = jsonData["data"];

        Logger().i(data);

        return SalesIncentiveResponse.fromJson(data);

      } else {
        Fluttertoast.showToast(msg: "Unable to fetch Sales Incentive");
        return null;
      }

    } catch (e) {
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("ERROR DATA: ${e.response?.data}");
        print("URL: ${e.requestOptions.path}");
      } else {
        print("ERROR: $e");
      }

      Logger().e(e);
      Fluttertoast.showToast(msg: "Error fetching Sales Incentive");
      return null;
    }
  }
}