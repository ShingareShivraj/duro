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


  // ───────────────────────── Commission Dashboard ─────────────────────────

  CommissionDashboard? _commissionDashboard;

  CommissionDashboard? get commissionDashboard => _commissionDashboard;

  DateTime selectedCommissionMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  String? selectedCommissionSalesPerson;

  bool commissionLoading = false;
  String? commissionError;

  int _commissionRequestId = 0;

  bool get hasCommissionDashboard => _commissionDashboard != null;

  bool get isCommissionSalesManager =>
      _commissionDashboard?.isSalesManager == true;

  List<CommissionSalesPerson> get commissionSalesPersons =>
      _commissionDashboard?.salesPersons ??
          const <CommissionSalesPerson>[];


  List<CustomerCommissionOpportunity>
  get customerCommissionOpportunities =>
      _commissionDashboard?.customerOpportunities ??
          const <CustomerCommissionOpportunity>[];

  CustomerOpportunitySummary get customerOpportunitySummary =>
      _commissionDashboard?.customerOpportunitySummary ??
          const CustomerOpportunitySummary.empty();

  bool get hasCustomerCommissionOpportunities =>
      customerCommissionOpportunities.isNotEmpty;

  String get customerOpportunityEmptyMessage {
    final dashboard = _commissionDashboard;

    if (dashboard == null) {
      return 'Create a new customer or reactivate an inactive '
          'customer to earn additional commission.';
    }

    if (dashboard.isSalesManager) {
      final salesPersonName =
          dashboard.selectedSalesPerson?.displayName ??
              'Selected salesperson';

      return '$salesPersonName has no new or reactivated '
          'customer commission opportunity for this month.';
    }

    return 'Create a new customer or reactivate a customer '
        'who has not purchased during the last 30 days. '
        'Complete the required sales and earn additional commission.';
  }

  String get selectedCommissionSalesPersonName =>
      _commissionDashboard?.selectedSalesPerson?.displayName ??
          'Sales Person';


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

      final results = await Future.wait<dynamic>([
        _service.dashboard(selectedPeriod),
        _service.getEmpName(),
        _service.fetchRoles(),
        _service.commissionDashboard(
          month: selectedCommissionMonth,
          showError: false,
        ),
      ]);

      _commit(() {
        _dashboard = results[0] as DashBoard?;
        employeeData = results[1] as EmpData?;
        availableDocTypes =
            (results[2] as List).map((e) => e.toString()).toList();

        _commissionDashboard = results[3] as CommissionDashboard?;

        selectedCommissionSalesPerson =
            _commissionDashboard?.selectedSalesPerson?.name;

        final backendMonth =
        DateTime.tryParse(_commissionDashboard?.period?.monthValue ?? '');

        if (backendMonth != null) {
          selectedCommissionMonth = DateTime(
            backendMonth.year,
            backendMonth.month,
            1,
          );
        }

        commissionError = null;
        commissionLoading = false;

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

  Future<void> changeCommissionMonth(DateTime month) async {
    final normalizedMonth = DateTime(
      month.year,
      month.month,
      1,
    );

    if (selectedCommissionMonth.year == normalizedMonth.year &&
        selectedCommissionMonth.month == normalizedMonth.month) {
      return;
    }

    selectedCommissionMonth = normalizedMonth;
    notifyListeners();

    await _loadCommissionDashboard(
      salesPerson: selectedCommissionSalesPerson,
    );
  }

  Future<void> changeCommissionSalesPerson(
      String? salesPerson,
      ) async {
    final normalizedValue = salesPerson?.trim();

    if (normalizedValue == null ||
        normalizedValue.isEmpty ||
        normalizedValue == selectedCommissionSalesPerson) {
      return;
    }

    selectedCommissionSalesPerson = normalizedValue;
    notifyListeners();

    await _loadCommissionDashboard(
      salesPerson: normalizedValue,
    );
  }

  Future<void> retryCommissionDashboard() async {
    await _loadCommissionDashboard(
      salesPerson: selectedCommissionSalesPerson,
    );
  }

  Future<void> _loadCommissionDashboard({
    String? salesPerson,
    bool showError = true,
  }) async {
    final requestId = ++_commissionRequestId;

    commissionLoading = true;
    commissionError = null;
    notifyListeners();

    try {
      final result = await _service.commissionDashboard(
        month: selectedCommissionMonth,
        salesPerson: salesPerson,
        showError: showError,
      );

      // Ignore an older request if a newer selection was made.
      if (requestId != _commissionRequestId) {
        return;
      }

      if (result == null) {
        commissionError = 'Unable to load commission details';
        return;
      }

      _commissionDashboard = result;

      selectedCommissionSalesPerson =
          result.selectedSalesPerson?.name;

      final backendMonth =
      DateTime.tryParse(result.period?.monthValue ?? '');

      if (backendMonth != null) {
        selectedCommissionMonth = DateTime(
          backendMonth.year,
          backendMonth.month,
          1,
        );
      }

      commissionError = null;
    } catch (error, stackTrace) {
      if (requestId != _commissionRequestId) {
        return;
      }

      commissionError = 'Unable to load commission details';

      _log.e(
        'Commission dashboard failed',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (requestId == _commissionRequestId) {
        commissionLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh() async {
    try {
      final results = await Future.wait<dynamic>([
        _service.dashboard(
          selectedPeriod,
          range: selectedRange,
        ),
        _service.commissionDashboard(
          month: selectedCommissionMonth,
          salesPerson: selectedCommissionSalesPerson,
          showError: false,
        ),
      ]);

      final dashboardData = results[0] as DashBoard?;
      final commissionData = results[1] as CommissionDashboard?;

      if (dashboardData != null) {
        _dashboard = dashboardData;
        territoryList = dashboardData.territorylist ?? [];

        salesList = dashboardData.salesPerson ?? [];
        weekData = _weeklyData(salesList);

        isCheckedIn = dashboardData.lastLogType == "IN";
        _cachedSpendHours = null;
      }

      // Preserve old commission data if only its refresh failed.
      if (commissionData != null) {
        _commissionDashboard = commissionData;

        selectedCommissionSalesPerson =
            commissionData.selectedSalesPerson?.name;

        commissionError = null;
      }

      notifyListeners();
    } catch (error, stackTrace) {
      _log.e(
        'Dashboard refresh failed',
        error: error,
        stackTrace: stackTrace,
      );

      Fluttertoast.showToast(
        msg: "Failed to refresh data",
      );
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
