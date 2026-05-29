import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/dashboard.dart';
import '../../model/emp_data.dart';
import '../../router.router.dart';
import '../../services/geolocation_services.dart';
import '../../services/home_services.dart';
import '../tracking_screen/background_service.dart';
class HomeViewModel extends BaseViewModel {
  final HomeServices _service = HomeServices();
  final Logger _log = Logger();
  final GeolocationService _geoService = GeolocationService();

  // ───────────────────────────────────────── Core Data ─────────────────────────────────────────
  DashBoard? _dashboard;
  DashBoard get dashboard => _dashboard!;

  EmpData? employeeData;
  List<String> availableDocTypes = [];

  bool checkInStatusLoaded = false;
  bool isCheckedIn = false;
  bool isHide = false;

  bool lazyDataLoaded = false;
  bool loadingIn = false;
  bool loadingOut = false;


  List<SalesPerson> salesList = [];
  List<SalesPerson> weekData = [];

  String greeting = "";
  String selectedPeriod = "Monthly";
  DateTimeRange? selectedRange;
  // ───────────────────────────────────────── Territory ─────────────────────────────────────────
  String? selectedTerritory;
  List<String> territoryList = [];

  // ───────────────────────────────────────── Spend Hours Cache ─────────────────────────────────────────
  String? _cachedSpendHours;
  Timer? _spendTimer;

  // ───────────────────────────────────────── Location ─────────────────────────────────────────
  Position? currentPosition;
  String currentAddress = "Fetching location...";
  bool locationLoading = false;

  // ───────────────────────────────────────── SharedPrefs ─────────────────────────────────────────
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _prefsInstance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ───────────────────────────────────────── Helpers ─────────────────────────────────────────
  void _commit(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // ───────────────────────────────────────── INIT ─────────────────────────────────────────
  Future<void> initialize(BuildContext context) async {
    try {
      final prefs = await _prefsInstance;

      final results = await Future.wait([
        _service.dashboard(selectedPeriod),
        _service.getEmpName(),
        _service.fetchRoles(),
      ]);

      _commit(() {
        _dashboard = results[0] as DashBoard?;
        employeeData = results[1] as EmpData?;
        availableDocTypes =
            (results[2] as List).map((e) => e.toString()).toList();

        isCheckedIn = _dashboard?.lastLogType == "IN";
        territoryList = _dashboard?.territorylist ?? [];
        selectedTerritory = prefs.getString("selected_territory");

        if (selectedTerritory != null &&
            !territoryList.contains(selectedTerritory)) {
          selectedTerritory = null;
          prefs.remove("selected_territory");
        }


        salesList = _dashboard?.salesPerson ?? [];
        weekData = _weeklyData(salesList);

        _updateGreeting();
        isHide = _dashboard?.empName == null;
        checkInStatusLoaded = true;
      });

      _startSpendTimer();
    } catch (e, st) {
      _log.e("Init failed", error: e, stackTrace: st);

      // ✅ Detect authentication error
      if (_isAuthError(e)) {
        logout(context);
        return;
      }

      Fluttertoast.showToast(
        msg: "Failed to load dashboard",
      );
    }
  }


  Future<void> changePeriod(
      String period, {
        DateTimeRange? range,
      }) async {

    selectedPeriod = period;

    if (range != null) {
      selectedRange = range;
    }

    setBusy(true);

    final data = await _service.dashboard(
      period,
      range: selectedRange,
    );

    if (data != null) {
      _dashboard = data;
      notifyListeners();
    }

    setBusy(false);
  }


  Future<void> openCustomRangePicker(
      BuildContext context,
      ) async {

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
      saveText: "Apply",
    );

    if (result != null) {

      selectedRange = result;

      await changePeriod(
        "Custom Range",
        range: result,
      );
    }
  }

  bool _isAuthError(Object error) {
    // If using Dio
    if (error is DioException) {
      return error.response?.statusCode == 401;
    }

    // If using http package
    if (error.toString().contains("401") ||
        error.toString().toLowerCase().contains("unauthorized")) {
      return true;
    }

    return false;
  }

  // ───────────────────────────────────────── GREETING ─────────────────────────────────────────
  void _updateGreeting() {
    final hour = DateTime.now().hour;
    greeting = hour < 12
        ? "Good Morning"
        : hour < 17
            ? "Good Afternoon"
            : "Good Evening";
  }

  // ───────────────────────────────────────── WEEK DATA ─────────────────────────────────────────
  List<SalesPerson> _weeklyData(List<SalesPerson> list) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 6));

    return list.where((e) {
      if (e.date == null) return false;
      final d = DateTime.parse(e.date!);
      return d.isAfter(start.subtract(const Duration(days: 1))) &&
          d.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  bool isFormAvailableForDocType(String docType) =>
      availableDocTypes.contains(docType);
  // ───────────────────────────────────────── SPEND HOURS ─────────────────────────────────────────
  String get spendHours {
    if (_cachedSpendHours != null) return _cachedSpendHours!;

    if (_dashboard?.inTime?.isEmpty ?? true) return "0 Hrs";

    try {
      final formatter = DateFormat("dd-MMM hh:mma yyyy");
      final now = DateTime.now();

      final inTime = formatter.parse("${_dashboard!.inTime} ${now.year}");
      final outTime = (_dashboard!.outTime?.isNotEmpty ?? false)
          ? formatter.parse("${_dashboard!.outTime} ${now.year}")
          : now;

      final hrs = outTime.difference(inTime).inMinutes / 60;
      return _cachedSpendHours = "${hrs.toStringAsFixed(2)} Hrs";
    } catch (_) {
      return "0 Hrs";
    }
  }

  void _startSpendTimer() {
    _spendTimer?.cancel();
    _spendTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _cachedSpendHours = null;
      notifyListeners();
    });
  }


  // ───────────────────────────────────────── TERRITORY ─────────────────────────────────────────
  Future<void> setSelectedTerritory(String value) async {
    final prefs = await _prefsInstance;
    _commit(() {
      selectedTerritory = value;
      prefs.setString("selected_territory", value);
    });
  }

  Future<void> onRefresh() async {
    try {
      final dashboard = await _service.dashboard(
        selectedPeriod,
        range: selectedRange,
      );
      if (dashboard == null) return;

      _dashboard = dashboard;
      territoryList = dashboard.territorylist ?? [];

      salesList = dashboard.salesPerson ?? [];
      weekData = _weeklyData(salesList);

      isCheckedIn = dashboard.lastLogType == "IN";

      _cachedSpendHours = null;
      notifyListeners();
    } catch (_) {
      Fluttertoast.showToast(msg: "Failed to refresh data");
    }
  }

  // ───────────────────────────────────────── CHECK-IN / OUT ─────────────────────────────────────────
  Future<bool> employeeLog(
    String logType,
    BuildContext context, {
    required File photoFile,
    String? meterReading,
    required Position position,
  }) async {
    _setLoading(logType, true);

    try {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        photoFile.path,
        "${photoFile.path}_compressed.jpg",
        quality: 60,
      );

      final success = await _service.employeeCheckin(
        logType: logType,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        meterReading: meterReading,
        photoFile: File(compressed?.path ?? photoFile.path),
      );

      if (!success) return false;
      final prefs = await SharedPreferences.getInstance();
      if (logType == "IN") {
        await prefs.setBool("is_checked_in", true);
        await initializeService();
      } else {
        await prefs.setBool("is_checked_in", false);
        final service = FlutterBackgroundService();
        service.invoke("stopService");
      }
      _commit(() {
        isCheckedIn = logType == "IN";
        _cachedSpendHours = null;
      });

      _dashboard = await _service.dashboard(selectedPeriod);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to record log");
      return false;
    } finally {
      _setLoading(logType, false);
    }
  }

  void _setLoading(String type, bool v) {
    _commit(() {
      type == "IN" ? loadingIn = v : loadingOut = v;
    });
  }

  // ───────────────────────────────────────── LOGOUT ─────────────────────────────────────────
  Future<void> handleLogout(BuildContext context) async {
    _prefs?.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginViewScreen,
        (_) => false,
      );
    }
  }

  // ───────────────────────────────────────── DISPOSE ─────────────────────────────────────────
  @override
  void dispose() {
    _spendTimer?.cancel();
    super.dispose();
  }
}
