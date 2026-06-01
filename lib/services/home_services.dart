import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocation/model/attendance_dashboard_model.dart';
import 'package:geolocation/model/emp_data.dart';
import 'package:geolocation/model/leave_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../model/dashboard.dart';

class HomeServices {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<DashBoard?> dashboard(
      String period, {
        DateTimeRange? range,
      }) async {
    try {
      String url =
          '${await geturl()}/api/method/mobile.mobile_env.app.get_dashboard?period=$period';

      if (range != null) {

        final from =
        DateFormat('yyyy-MM-dd').format(range.start);

        final to =
        DateFormat('yyyy-MM-dd').format(range.end);

        url += '&from_date=$from&to_date=$to';
      }


      print("================================");
      print("PERIOD : $period");
      print("RANGE  : $range");

      if (range != null) {
        print("START  : ${range.start}");
        print("END    : ${range.end}");
      }

      print("URL    : $url");
      print("================================");
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200) {

        print("===== FULL DASHBOARD RESPONSE =====");
        print(response.data);

        print("===== LEADERBOARD DATA =====");
        print(response.data["data"]["leaderboard"]);

        return DashBoard.fromJson(response.data["data"]);
      } else {
        _showToast("Unable to load dashboard data");
      }
    } catch (e) {
      _logger.e(e);
      _handleDioError(e, context: "dashboard");
    }
    return null;
  }

  Future<EmpData?> getEmpName() async {
    try {
      final url =
          '${await geturl()}/api/method/mobile.mobile_env.app.get_emp_name';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        return EmpData.fromJson(response.data["data"]);
      } else {
        _showToast("Unable to load employee data");
      }
    } catch (e) {
      _handleDioError(e, context: "getEmpName");
    }
    return null;
  }

  Future<bool> employeeCheckin({
    required String logType,
    required String latitude,
    required String longitude,
    required File photoFile,
    String? meterReading,
  }) async {
    try {
      final url =
          '${await geturl()}/api/method/mobile.mobile_env.app.create_employee_log';

      final formData = FormData.fromMap({
        "log_type": logType,
        "latitude": latitude,
        "longitude": longitude,
        "meter_reading": meterReading,
        "photo": await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last, // IMPORTANT
        ),
      });
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {
          'Authorization': await getTocken(),
        }),
      );

      if (response.statusCode == 200 && response.data["message"] != null) {
        _showToast(
          response.data["message"].toString().toUpperCase(),
          success: true,
        );
        return true;
      } else {
        _showToast("Unable to log employee check-in/out");
      }
    } on DioException catch (e) {
      print(e.response);
      _handleDioError(e.response, context: "employeeCheckin");
    }
    return false;
  }

  Future<List<LeaveData>> fetchleavedata() async {
    try {
      final url =
          '${await geturl()}/api/method/mobile.mobile_env.app.get_leave_balance_dashboard';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']?['leave_balance'] ?? [];
        return List<LeaveData>.from(
            data.map((item) => LeaveData.fromJson(item)));
      } else {
        _showToast("Unable to fetch leave data");
      }
    } catch (e) {
      _handleDioError(e, context: "fetchLeaveData");
    }
    return [];
  }

  Future<AttendanceDashboard?> attendanceDashboard() async {
    try {
      final url =
          '${await geturl()}/api/method/mobile.mobile_env.app.get_attendance_details_dashboard';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        return AttendanceDashboard.fromJson(response.data["data"]);
      } else {
        _showToast("Unable to load attendance data");
      }
    } catch (e) {
      _handleDioError(e, context: "attendanceDashboard");
    }
    return null;
  }

  Future<List<String>> fetchRoles() async {
    try {
      final url =
          '${await geturl()}/api/method/mobile.mobile_env.app.user_has_permission';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': await getTocken()}),
      );

      if (response.statusCode == 200 && response.data["message"] != null) {
        return List<String>.from(
            response.data["message"].map((item) => item.toString()));
      } else {
        _showToast("Unable to fetch roles");
      }
    } catch (e) {
      _handleDioError(e, context: "fetchRoles");
    }
    return [];
  }

  /// Handles DioException and logs properly
  void _handleDioError(dynamic error, {String? context}) {
    String message = "Unexpected error";

    if (error is DioException) {
      final responseMessage =
          error.response?.data?["message"] ?? error.response?.data;
      message = "Error: $responseMessage";
    } else if (error is Exception) {
      message = error.toString();
    }

    _showToast(message, isError: true);
    _logger.e('[$context] $message');
  }

  /// Shows a consistent toast message for success or error
  void _showToast(String msg, {bool isError = false, bool success = false}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      textColor: const Color(0xFFFFFFFF),
      backgroundColor: isError
          ? const Color(0xFFBA1A1A)
          : success
              ? const Color.fromARGB(255, 26, 186, 29)
              : const Color(0xFF666666),
    );
  }
}
