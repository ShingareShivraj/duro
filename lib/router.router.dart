// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i40;
import 'package:flutter/material.dart';
import 'package:geolocation/model/add_order_model.dart' as _i41;
import 'package:geolocation/model/addquotation_model.dart' as _i42;
import 'package:geolocation/screens/attendence_screen/attendence_view.dart'
    as _i19;
import 'package:geolocation/screens/change_password/change_password_screen.dart'
    as _i25;
import 'package:geolocation/screens/customer_screen/add_customer/add_customer_view.dart'
    as _i27;
import 'package:geolocation/screens/customer_screen/customer_list/customer_list_screen.dart'
    as _i26;
import 'package:geolocation/screens/customer_screen/Update_Customer/update_customer_screen.dart'
    as _i28;
import 'package:geolocation/screens/delivery_note.dart' as _i34;
import 'package:geolocation/screens/delivery_note_list.dart' as _i33;
import 'package:geolocation/screens/Distributor%20Sales%20Order/add_sales_order/add_distributor_order_screen.dart'
    as _i10;
import 'package:geolocation/screens/Distributor%20Sales%20Order/list_sales_order/list_sales_distributor_order_screen.dart'
    as _i9;
import 'package:geolocation/screens/expense_screen/add_expense/add_expense_view.dart'
    as _i21;
import 'package:geolocation/screens/expense_screen/list_expense/list_expense_view.dart'
    as _i20;
import 'package:geolocation/screens/geolocation/geolocation_view.dart' as _i5;
import 'package:geolocation/screens/holiday_screen/holiday_view.dart' as _i18;
import 'package:geolocation/screens/home_screen/home_page.dart' as _i3;
import 'package:geolocation/screens/lead_screen/add_lead_screen/add_lead_screen.dart'
    as _i13;
import 'package:geolocation/screens/lead_screen/lead_list/lead_screen.dart'
    as _i12;
import 'package:geolocation/screens/lead_screen/update_screen/update_screen.dart'
    as _i14;
import 'package:geolocation/screens/leave_screen/add_leave/add_leave_view.dart'
    as _i23;
import 'package:geolocation/screens/leave_screen/list_leave/list_leave_view.dart'
    as _i22;
import 'package:geolocation/screens/location_tracking/location_tracker.dart'
    as _i6;
import 'package:geolocation/screens/login/login_view.dart' as _i4;
import 'package:geolocation/screens/profile_screen/profile_screen.dart' as _i24;
import 'package:geolocation/screens/Quotation/Add%20Quotation/add_quotation_screen.dart'
    as _i15;
import 'package:geolocation/screens/Quotation/Items/items_screen.dart' as _i17;
import 'package:geolocation/screens/Quotation/List%20Quotation/list_quotation_view.dart'
    as _i16;
import 'package:geolocation/screens/reports/leaderboard/leaderboard_screen.dart'
    as _i38;
import 'package:geolocation/screens/reports/territory_summary/territory_summary_screen.dart'
    as _i39;
import 'package:geolocation/screens/retailer_registration/add_retailer/add_retailer_screen.dart'
    as _i32;
import 'package:geolocation/screens/sales_incentive/sales_incentive_screen.dart'
    as _i37;
import 'package:geolocation/screens/sales_order/add_sales_order/add_order_screen.dart'
    as _i8;
import 'package:geolocation/screens/sales_order/items/add_items_screen.dart'
    as _i11;
import 'package:geolocation/screens/sales_order/list_sales_order/list_sales_order_screen.dart'
    as _i7;
import 'package:geolocation/screens/self_orders/items/add_self_order_screen.dart'
    as _i36;
import 'package:geolocation/screens/self_orders/list_sales_order/list_self_order_screen.dart'
    as _i35;
import 'package:geolocation/screens/splash_screen/splash_screen.dart' as _i2;
import 'package:geolocation/screens/visit_screens/add_visit/add_visit_view.dart'
    as _i30;
import 'package:geolocation/screens/visit_screens/update_visit/update_visit_view.dart'
    as _i31;
import 'package:geolocation/screens/visit_screens/visit_List/visit_list_screen.dart'
    as _i29;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i43;

class Routes {
  static const splashScreen = '/';

  static const homePage = '/home-page';

  static const loginViewScreen = '/login-view-screen';

  static const geolocation = '/Geolocation';

  static const locationTracker = '/location-tracker';

  static const listOrderScreen = '/list-order-screen';

  static const addOrderScreen = '/add-order-screen';

  static const listDistributorOrderScreen = '/list-distributor-order-screen';

  static const addDistributorOrderScreen = '/add-distributor-order-screen';

  static const itemScreen = '/item-screen';

  static const leadListScreen = '/lead-list-screen';

  static const addLeadScreen = '/add-lead-screen';

  static const updateLeadScreen = '/update-lead-screen';

  static const addQuotationView = '/add-quotation-view';

  static const listQuotationScreen = '/list-quotation-screen';

  static const quotationItemScreen = '/quotation-item-screen';

  static const holidayScreen = '/holiday-screen';

  static const attendanceScreen = '/attendance-screen';

  static const expenseScreen = '/expense-screen';

  static const addExpenseScreen = '/add-expense-screen';

  static const listLeaveScreen = '/list-leave-screen';

  static const addLeaveScreen = '/add-leave-screen';

  static const profileScreen = '/profile-screen';

  static const changePasswordScreen = '/change-password-screen';

  static const customerList = '/customer-list';

  static const addCustomer = '/add-customer';

  static const updateCustomer = '/update-customer';

  static const visitScreen = '/visit-screen';

  static const addVisitScreen = '/add-visit-screen';

  static const updateVisitScreen = '/update-visit-screen';

  static const retailerFormView = '/retailer-form-view';

  static const listDeliveryNoteScreen = '/list-delivery-note-screen';

  static const deliveryNoteScreen = '/delivery-note-screen';

  static const listSelfOrderScreen = '/list-self-order-screen';

  static const createSelfOrderScreen = '/create-self-order-screen';

  static const salesIncentiveScreen = '/sales-incentive-screen';

  static const leaderboardScreen = '/leaderboard-screen';

  static const territorySummaryScreen = '/territory-summary-screen';

  static const all = <String>{
    splashScreen,
    homePage,
    loginViewScreen,
    geolocation,
    locationTracker,
    listOrderScreen,
    addOrderScreen,
    listDistributorOrderScreen,
    addDistributorOrderScreen,
    itemScreen,
    leadListScreen,
    addLeadScreen,
    updateLeadScreen,
    addQuotationView,
    listQuotationScreen,
    quotationItemScreen,
    holidayScreen,
    attendanceScreen,
    expenseScreen,
    addExpenseScreen,
    listLeaveScreen,
    addLeaveScreen,
    profileScreen,
    changePasswordScreen,
    customerList,
    addCustomer,
    updateCustomer,
    visitScreen,
    addVisitScreen,
    updateVisitScreen,
    retailerFormView,
    listDeliveryNoteScreen,
    deliveryNoteScreen,
    listSelfOrderScreen,
    createSelfOrderScreen,
    salesIncentiveScreen,
    leaderboardScreen,
    territorySummaryScreen,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.splashScreen, page: _i2.SplashScreen),
    _i1.RouteDef(Routes.homePage, page: _i3.HomePage),
    _i1.RouteDef(Routes.loginViewScreen, page: _i4.LoginViewScreen),
    _i1.RouteDef(Routes.geolocation, page: _i5.Geolocation),
    _i1.RouteDef(Routes.locationTracker, page: _i6.LocationTracker),
    _i1.RouteDef(Routes.listOrderScreen, page: _i7.ListOrderScreen),
    _i1.RouteDef(Routes.addOrderScreen, page: _i8.AddOrderScreen),
    _i1.RouteDef(
      Routes.listDistributorOrderScreen,
      page: _i9.ListDistributorOrderScreen,
    ),
    _i1.RouteDef(
      Routes.addDistributorOrderScreen,
      page: _i10.AddDistributorOrderScreen,
    ),
    _i1.RouteDef(Routes.itemScreen, page: _i11.ItemScreen),
    _i1.RouteDef(Routes.leadListScreen, page: _i12.LeadListScreen),
    _i1.RouteDef(Routes.addLeadScreen, page: _i13.AddLeadScreen),
    _i1.RouteDef(Routes.updateLeadScreen, page: _i14.UpdateLeadScreen),
    _i1.RouteDef(Routes.addQuotationView, page: _i15.AddQuotationView),
    _i1.RouteDef(Routes.listQuotationScreen, page: _i16.ListQuotationScreen),
    _i1.RouteDef(Routes.quotationItemScreen, page: _i17.QuotationItemScreen),
    _i1.RouteDef(Routes.holidayScreen, page: _i18.HolidayScreen),
    _i1.RouteDef(Routes.attendanceScreen, page: _i19.AttendanceScreen),
    _i1.RouteDef(Routes.expenseScreen, page: _i20.ExpenseScreen),
    _i1.RouteDef(Routes.addExpenseScreen, page: _i21.AddExpenseScreen),
    _i1.RouteDef(Routes.listLeaveScreen, page: _i22.ListLeaveScreen),
    _i1.RouteDef(Routes.addLeaveScreen, page: _i23.AddLeaveScreen),
    _i1.RouteDef(Routes.profileScreen, page: _i24.ProfileScreen),
    _i1.RouteDef(Routes.changePasswordScreen, page: _i25.ChangePasswordScreen),
    _i1.RouteDef(Routes.customerList, page: _i26.CustomerList),
    _i1.RouteDef(Routes.addCustomer, page: _i27.AddCustomer),
    _i1.RouteDef(Routes.updateCustomer, page: _i28.UpdateCustomer),
    _i1.RouteDef(Routes.visitScreen, page: _i29.VisitScreen),
    _i1.RouteDef(Routes.addVisitScreen, page: _i30.AddVisitScreen),
    _i1.RouteDef(Routes.updateVisitScreen, page: _i31.UpdateVisitScreen),
    _i1.RouteDef(Routes.retailerFormView, page: _i32.RetailerFormView),
    _i1.RouteDef(
      Routes.listDeliveryNoteScreen,
      page: _i33.ListDeliveryNoteScreen,
    ),
    _i1.RouteDef(Routes.deliveryNoteScreen, page: _i34.DeliveryNoteScreen),
    _i1.RouteDef(Routes.listSelfOrderScreen, page: _i35.ListSelfOrderScreen),
    _i1.RouteDef(
      Routes.createSelfOrderScreen,
      page: _i36.CreateSelfOrderScreen,
    ),
    _i1.RouteDef(Routes.salesIncentiveScreen, page: _i37.SalesIncentiveScreen),
    _i1.RouteDef(Routes.leaderboardScreen, page: _i38.LeaderboardScreen),
    _i1.RouteDef(
      Routes.territorySummaryScreen,
      page: _i39.TerritorySummaryScreen,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashScreen: (data) {
      final args = data.getArgs<SplashScreenArguments>(
        orElse: () => const SplashScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SplashScreen(key: args.key),
        settings: data,
      );
    },
    _i3.HomePage: (data) {
      final args = data.getArgs<HomePageArguments>(
        orElse: () => const HomePageArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.HomePage(key: args.key),
        settings: data,
      );
    },
    _i4.LoginViewScreen: (data) {
      final args = data.getArgs<LoginViewScreenArguments>(
        orElse: () => const LoginViewScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LoginViewScreen(key: args.key),
        settings: data,
      );
    },
    _i5.Geolocation: (data) {
      final args = data.getArgs<GeolocationArguments>(
        orElse: () => const GeolocationArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.Geolocation(key: args.key),
        settings: data,
      );
    },
    _i6.LocationTracker: (data) {
      final args = data.getArgs<LocationTrackerArguments>(
        orElse: () => const LocationTrackerArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.LocationTracker(key: args.key),
        settings: data,
      );
    },
    _i7.ListOrderScreen: (data) {
      final args = data.getArgs<ListOrderScreenArguments>(
        orElse: () => const ListOrderScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ListOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i8.AddOrderScreen: (data) {
      final args = data.getArgs<AddOrderScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.AddOrderScreen(key: args.key, orderid: args.orderid),
        settings: data,
      );
    },
    _i9.ListDistributorOrderScreen: (data) {
      final args = data.getArgs<ListDistributorOrderScreenArguments>(
        orElse: () => const ListDistributorOrderScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.ListDistributorOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i10.AddDistributorOrderScreen: (data) {
      final args = data.getArgs<AddDistributorOrderScreenArguments>(
        nullOk: false,
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.AddDistributorOrderScreen(
          key: args.key,
          orderId: args.orderId,
        ),
        settings: data,
      );
    },
    _i11.ItemScreen: (data) {
      final args = data.getArgs<ItemScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.ItemScreen(
          key: args.key,
          warehouse: args.warehouse,
          items: args.items,
          selectedItems: args.selectedItems,
        ),
        settings: data,
      );
    },
    _i12.LeadListScreen: (data) {
      final args = data.getArgs<LeadListScreenArguments>(
        orElse: () => const LeadListScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.LeadListScreen(key: args.key),
        settings: data,
      );
    },
    _i13.AddLeadScreen: (data) {
      final args = data.getArgs<AddLeadScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i13.AddLeadScreen(key: args.key, leadId: args.leadId),
        settings: data,
      );
    },
    _i14.UpdateLeadScreen: (data) {
      final args = data.getArgs<UpdateLeadScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i14.UpdateLeadScreen(key: args.key, updateId: args.updateId),
        settings: data,
      );
    },
    _i15.AddQuotationView: (data) {
      final args = data.getArgs<AddQuotationViewArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i15.AddQuotationView(key: args.key, quotationid: args.quotationid),
        settings: data,
      );
    },
    _i16.ListQuotationScreen: (data) {
      final args = data.getArgs<ListQuotationScreenArguments>(
        orElse: () => const ListQuotationScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i16.ListQuotationScreen(key: args.key),
        settings: data,
      );
    },
    _i17.QuotationItemScreen: (data) {
      final args = data.getArgs<QuotationItemScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i17.QuotationItemScreen(key: args.key, items: args.items),
        settings: data,
      );
    },
    _i18.HolidayScreen: (data) {
      final args = data.getArgs<HolidayScreenArguments>(
        orElse: () => const HolidayScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i18.HolidayScreen(key: args.key),
        settings: data,
      );
    },
    _i19.AttendanceScreen: (data) {
      final args = data.getArgs<AttendanceScreenArguments>(
        orElse: () => const AttendanceScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.AttendanceScreen(key: args.key),
        settings: data,
      );
    },
    _i20.ExpenseScreen: (data) {
      final args = data.getArgs<ExpenseScreenArguments>(
        orElse: () => const ExpenseScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i20.ExpenseScreen(key: args.key),
        settings: data,
      );
    },
    _i21.AddExpenseScreen: (data) {
      final args = data.getArgs<AddExpenseScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i21.AddExpenseScreen(key: args.key, expenseId: args.expenseId),
        settings: data,
      );
    },
    _i22.ListLeaveScreen: (data) {
      final args = data.getArgs<ListLeaveScreenArguments>(
        orElse: () => const ListLeaveScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i22.ListLeaveScreen(key: args.key),
        settings: data,
      );
    },
    _i23.AddLeaveScreen: (data) {
      final args = data.getArgs<AddLeaveScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i23.AddLeaveScreen(key: args.key, leaveId: args.leaveId),
        settings: data,
      );
    },
    _i24.ProfileScreen: (data) {
      final args = data.getArgs<ProfileScreenArguments>(
        orElse: () => const ProfileScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i24.ProfileScreen(key: args.key),
        settings: data,
      );
    },
    _i25.ChangePasswordScreen: (data) {
      final args = data.getArgs<ChangePasswordScreenArguments>(
        orElse: () => const ChangePasswordScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i25.ChangePasswordScreen(key: args.key),
        settings: data,
      );
    },
    _i26.CustomerList: (data) {
      final args = data.getArgs<CustomerListArguments>(
        orElse: () => const CustomerListArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i26.CustomerList(key: args.key),
        settings: data,
      );
    },
    _i27.AddCustomer: (data) {
      final args = data.getArgs<AddCustomerArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i27.AddCustomer(key: args.key, id: args.id),
        settings: data,
      );
    },
    _i28.UpdateCustomer: (data) {
      final args = data.getArgs<UpdateCustomerArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i28.UpdateCustomer(key: args.key, id: args.id),
        settings: data,
      );
    },
    _i29.VisitScreen: (data) {
      final args = data.getArgs<VisitScreenArguments>(
        orElse: () => const VisitScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i29.VisitScreen(key: args.key),
        settings: data,
      );
    },
    _i30.AddVisitScreen: (data) {
      final args = data.getArgs<AddVisitScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i30.AddVisitScreen(key: args.key, VisitId: args.VisitId),
        settings: data,
      );
    },
    _i31.UpdateVisitScreen: (data) {
      final args = data.getArgs<UpdateVisitScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i31.UpdateVisitScreen(key: args.key, updateId: args.updateId),
        settings: data,
      );
    },
    _i32.RetailerFormView: (data) {
      final args = data.getArgs<RetailerFormViewArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i32.RetailerFormView(key: args.key, retailerId: args.retailerId),
        settings: data,
      );
    },
    _i33.ListDeliveryNoteScreen: (data) {
      final args = data.getArgs<ListDeliveryNoteScreenArguments>(
        orElse: () => const ListDeliveryNoteScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i33.ListDeliveryNoteScreen(key: args.key),
        settings: data,
      );
    },
    _i34.DeliveryNoteScreen: (data) {
      final args = data.getArgs<DeliveryNoteScreenArguments>(nullOk: false);
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i34.DeliveryNoteScreen(key: args.key, orderData: args.orderData),
        settings: data,
      );
    },
    _i35.ListSelfOrderScreen: (data) {
      final args = data.getArgs<ListSelfOrderScreenArguments>(
        orElse: () => const ListSelfOrderScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i35.ListSelfOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i36.CreateSelfOrderScreen: (data) {
      final args = data.getArgs<CreateSelfOrderScreenArguments>(
        orElse: () => const CreateSelfOrderScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i36.CreateSelfOrderScreen(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
    _i37.SalesIncentiveScreen: (data) {
      final args = data.getArgs<SalesIncentiveScreenArguments>(
        orElse: () => const SalesIncentiveScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i37.SalesIncentiveScreen(key: args.key),
        settings: data,
      );
    },
    _i38.LeaderboardScreen: (data) {
      final args = data.getArgs<LeaderboardScreenArguments>(
        orElse: () => const LeaderboardScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i38.LeaderboardScreen(key: args.key),
        settings: data,
      );
    },
    _i39.TerritorySummaryScreen: (data) {
      final args = data.getArgs<TerritorySummaryScreenArguments>(
        orElse: () => const TerritorySummaryScreenArguments(),
      );
      return _i40.MaterialPageRoute<dynamic>(
        builder: (context) => _i39.TerritorySummaryScreen(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SplashScreenArguments {
  const SplashScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SplashScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HomePageArguments {
  const HomePageArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomePageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewScreenArguments {
  const LoginViewScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class GeolocationArguments {
  const GeolocationArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant GeolocationArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LocationTrackerArguments {
  const LocationTrackerArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LocationTrackerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ListOrderScreenArguments {
  const ListOrderScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddOrderScreenArguments {
  const AddOrderScreenArguments({this.key, required this.orderid});

  final _i40.Key? key;

  final String orderid;

  @override
  String toString() {
    return '{"key": "$key", "orderid": "$orderid"}';
  }

  @override
  bool operator ==(covariant AddOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderid == orderid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderid.hashCode;
  }
}

class ListDistributorOrderScreenArguments {
  const ListDistributorOrderScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListDistributorOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddDistributorOrderScreenArguments {
  const AddDistributorOrderScreenArguments({this.key, required this.orderId});

  final _i40.Key? key;

  final String orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant AddDistributorOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

class ItemScreenArguments {
  const ItemScreenArguments({
    this.key,
    required this.warehouse,
    required this.items,
    required this.selectedItems,
  });

  final _i40.Key? key;

  final String warehouse;

  final List<_i41.Items> items;

  final List<_i41.Items> selectedItems;

  @override
  String toString() {
    return '{"key": "$key", "warehouse": "$warehouse", "items": "$items", "selectedItems": "$selectedItems"}';
  }

  @override
  bool operator ==(covariant ItemScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.warehouse == warehouse &&
        other.items == items &&
        other.selectedItems == selectedItems;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        warehouse.hashCode ^
        items.hashCode ^
        selectedItems.hashCode;
  }
}

class LeadListScreenArguments {
  const LeadListScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LeadListScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddLeadScreenArguments {
  const AddLeadScreenArguments({this.key, required this.leadId});

  final _i40.Key? key;

  final String leadId;

  @override
  String toString() {
    return '{"key": "$key", "leadId": "$leadId"}';
  }

  @override
  bool operator ==(covariant AddLeadScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.leadId == leadId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ leadId.hashCode;
  }
}

class UpdateLeadScreenArguments {
  const UpdateLeadScreenArguments({this.key, required this.updateId});

  final _i40.Key? key;

  final String updateId;

  @override
  String toString() {
    return '{"key": "$key", "updateId": "$updateId"}';
  }

  @override
  bool operator ==(covariant UpdateLeadScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.updateId == updateId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ updateId.hashCode;
  }
}

class AddQuotationViewArguments {
  const AddQuotationViewArguments({this.key, required this.quotationid});

  final _i40.Key? key;

  final String quotationid;

  @override
  String toString() {
    return '{"key": "$key", "quotationid": "$quotationid"}';
  }

  @override
  bool operator ==(covariant AddQuotationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.quotationid == quotationid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ quotationid.hashCode;
  }
}

class ListQuotationScreenArguments {
  const ListQuotationScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListQuotationScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class QuotationItemScreenArguments {
  const QuotationItemScreenArguments({this.key, required this.items});

  final _i40.Key? key;

  final List<_i42.Items> items;

  @override
  String toString() {
    return '{"key": "$key", "items": "$items"}';
  }

  @override
  bool operator ==(covariant QuotationItemScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.items == items;
  }

  @override
  int get hashCode {
    return key.hashCode ^ items.hashCode;
  }
}

class HolidayScreenArguments {
  const HolidayScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HolidayScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AttendanceScreenArguments {
  const AttendanceScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant AttendanceScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ExpenseScreenArguments {
  const ExpenseScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ExpenseScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddExpenseScreenArguments {
  const AddExpenseScreenArguments({this.key, required this.expenseId});

  final _i40.Key? key;

  final String expenseId;

  @override
  String toString() {
    return '{"key": "$key", "expenseId": "$expenseId"}';
  }

  @override
  bool operator ==(covariant AddExpenseScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.expenseId == expenseId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ expenseId.hashCode;
  }
}

class ListLeaveScreenArguments {
  const ListLeaveScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListLeaveScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddLeaveScreenArguments {
  const AddLeaveScreenArguments({this.key, required this.leaveId});

  final _i40.Key? key;

  final String leaveId;

  @override
  String toString() {
    return '{"key": "$key", "leaveId": "$leaveId"}';
  }

  @override
  bool operator ==(covariant AddLeaveScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.leaveId == leaveId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ leaveId.hashCode;
  }
}

class ProfileScreenArguments {
  const ProfileScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ChangePasswordScreenArguments {
  const ChangePasswordScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ChangePasswordScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CustomerListArguments {
  const CustomerListArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CustomerListArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddCustomerArguments {
  const AddCustomerArguments({this.key, required this.id});

  final _i40.Key? key;

  final String id;

  @override
  String toString() {
    return '{"key": "$key", "id": "$id"}';
  }

  @override
  bool operator ==(covariant AddCustomerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.id == id;
  }

  @override
  int get hashCode {
    return key.hashCode ^ id.hashCode;
  }
}

class UpdateCustomerArguments {
  const UpdateCustomerArguments({this.key, required this.id});

  final _i40.Key? key;

  final String id;

  @override
  String toString() {
    return '{"key": "$key", "id": "$id"}';
  }

  @override
  bool operator ==(covariant UpdateCustomerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.id == id;
  }

  @override
  int get hashCode {
    return key.hashCode ^ id.hashCode;
  }
}

class VisitScreenArguments {
  const VisitScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant VisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddVisitScreenArguments {
  const AddVisitScreenArguments({this.key, required this.VisitId});

  final _i40.Key? key;

  final String VisitId;

  @override
  String toString() {
    return '{"key": "$key", "VisitId": "$VisitId"}';
  }

  @override
  bool operator ==(covariant AddVisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.VisitId == VisitId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ VisitId.hashCode;
  }
}

class UpdateVisitScreenArguments {
  const UpdateVisitScreenArguments({this.key, required this.updateId});

  final _i40.Key? key;

  final String updateId;

  @override
  String toString() {
    return '{"key": "$key", "updateId": "$updateId"}';
  }

  @override
  bool operator ==(covariant UpdateVisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.updateId == updateId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ updateId.hashCode;
  }
}

class RetailerFormViewArguments {
  const RetailerFormViewArguments({this.key, required this.retailerId});

  final _i40.Key? key;

  final String retailerId;

  @override
  String toString() {
    return '{"key": "$key", "retailerId": "$retailerId"}';
  }

  @override
  bool operator ==(covariant RetailerFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.retailerId == retailerId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ retailerId.hashCode;
  }
}

class ListDeliveryNoteScreenArguments {
  const ListDeliveryNoteScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListDeliveryNoteScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class DeliveryNoteScreenArguments {
  const DeliveryNoteScreenArguments({this.key, required this.orderData});

  final _i40.Key? key;

  final _i41.AddOrderModel orderData;

  @override
  String toString() {
    return '{"key": "$key", "orderData": "$orderData"}';
  }

  @override
  bool operator ==(covariant DeliveryNoteScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderData == orderData;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderData.hashCode;
  }
}

class ListSelfOrderScreenArguments {
  const ListSelfOrderScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListSelfOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CreateSelfOrderScreenArguments {
  const CreateSelfOrderScreenArguments({this.key, this.orderId = ""});

  final _i40.Key? key;

  final String orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant CreateSelfOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

class SalesIncentiveScreenArguments {
  const SalesIncentiveScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SalesIncentiveScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LeaderboardScreenArguments {
  const LeaderboardScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LeaderboardScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class TerritorySummaryScreenArguments {
  const TerritorySummaryScreenArguments({this.key});

  final _i40.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant TerritorySummaryScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i43.NavigationService {
  Future<dynamic> navigateToSplashScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.splashScreen,
      arguments: SplashScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomePage({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homePage,
      arguments: HomePageArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginViewScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginViewScreen,
      arguments: LoginViewScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToGeolocation({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.geolocation,
      arguments: GeolocationArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLocationTracker({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.locationTracker,
      arguments: LocationTrackerArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listOrderScreen,
      arguments: ListOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddOrderScreen({
    _i40.Key? key,
    required String orderid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addOrderScreen,
      arguments: AddOrderScreenArguments(key: key, orderid: orderid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListDistributorOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listDistributorOrderScreen,
      arguments: ListDistributorOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddDistributorOrderScreen({
    _i40.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addDistributorOrderScreen,
      arguments: AddDistributorOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToItemScreen({
    _i40.Key? key,
    required String warehouse,
    required List<_i41.Items> items,
    required List<_i41.Items> selectedItems,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.itemScreen,
      arguments: ItemScreenArguments(
        key: key,
        warehouse: warehouse,
        items: items,
        selectedItems: selectedItems,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLeadListScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.leadListScreen,
      arguments: LeadListScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddLeadScreen({
    _i40.Key? key,
    required String leadId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addLeadScreen,
      arguments: AddLeadScreenArguments(key: key, leadId: leadId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateLeadScreen({
    _i40.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateLeadScreen,
      arguments: UpdateLeadScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddQuotationView({
    _i40.Key? key,
    required String quotationid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addQuotationView,
      arguments: AddQuotationViewArguments(key: key, quotationid: quotationid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListQuotationScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listQuotationScreen,
      arguments: ListQuotationScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToQuotationItemScreen({
    _i40.Key? key,
    required List<_i42.Items> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.quotationItemScreen,
      arguments: QuotationItemScreenArguments(key: key, items: items),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHolidayScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.holidayScreen,
      arguments: HolidayScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAttendanceScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.attendanceScreen,
      arguments: AttendanceScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToExpenseScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.expenseScreen,
      arguments: ExpenseScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddExpenseScreen({
    _i40.Key? key,
    required String expenseId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addExpenseScreen,
      arguments: AddExpenseScreenArguments(key: key, expenseId: expenseId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListLeaveScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listLeaveScreen,
      arguments: ListLeaveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddLeaveScreen({
    _i40.Key? key,
    required String leaveId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addLeaveScreen,
      arguments: AddLeaveScreenArguments(key: key, leaveId: leaveId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProfileScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.profileScreen,
      arguments: ProfileScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToChangePasswordScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.changePasswordScreen,
      arguments: ChangePasswordScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCustomerList({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.customerList,
      arguments: CustomerListArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddCustomer({
    _i40.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addCustomer,
      arguments: AddCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateCustomer({
    _i40.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateCustomer,
      arguments: UpdateCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToVisitScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.visitScreen,
      arguments: VisitScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddVisitScreen({
    _i40.Key? key,
    required String VisitId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addVisitScreen,
      arguments: AddVisitScreenArguments(key: key, VisitId: VisitId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateVisitScreen({
    _i40.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateVisitScreen,
      arguments: UpdateVisitScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRetailerFormView({
    _i40.Key? key,
    required String retailerId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.retailerFormView,
      arguments: RetailerFormViewArguments(key: key, retailerId: retailerId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListDeliveryNoteScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listDeliveryNoteScreen,
      arguments: ListDeliveryNoteScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDeliveryNoteScreen({
    _i40.Key? key,
    required _i41.AddOrderModel orderData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.deliveryNoteScreen,
      arguments: DeliveryNoteScreenArguments(key: key, orderData: orderData),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListSelfOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listSelfOrderScreen,
      arguments: ListSelfOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCreateSelfOrderScreen({
    _i40.Key? key,
    String orderId = "",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.createSelfOrderScreen,
      arguments: CreateSelfOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSalesIncentiveScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.salesIncentiveScreen,
      arguments: SalesIncentiveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLeaderboardScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.leaderboardScreen,
      arguments: LeaderboardScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToTerritorySummaryScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.territorySummaryScreen,
      arguments: TerritorySummaryScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSplashScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.splashScreen,
      arguments: SplashScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomePage({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homePage,
      arguments: HomePageArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginViewScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginViewScreen,
      arguments: LoginViewScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithGeolocation({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.geolocation,
      arguments: GeolocationArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLocationTracker({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.locationTracker,
      arguments: LocationTrackerArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listOrderScreen,
      arguments: ListOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddOrderScreen({
    _i40.Key? key,
    required String orderid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addOrderScreen,
      arguments: AddOrderScreenArguments(key: key, orderid: orderid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListDistributorOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listDistributorOrderScreen,
      arguments: ListDistributorOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddDistributorOrderScreen({
    _i40.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addDistributorOrderScreen,
      arguments: AddDistributorOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithItemScreen({
    _i40.Key? key,
    required String warehouse,
    required List<_i41.Items> items,
    required List<_i41.Items> selectedItems,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.itemScreen,
      arguments: ItemScreenArguments(
        key: key,
        warehouse: warehouse,
        items: items,
        selectedItems: selectedItems,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLeadListScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.leadListScreen,
      arguments: LeadListScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddLeadScreen({
    _i40.Key? key,
    required String leadId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addLeadScreen,
      arguments: AddLeadScreenArguments(key: key, leadId: leadId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateLeadScreen({
    _i40.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateLeadScreen,
      arguments: UpdateLeadScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddQuotationView({
    _i40.Key? key,
    required String quotationid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addQuotationView,
      arguments: AddQuotationViewArguments(key: key, quotationid: quotationid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListQuotationScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listQuotationScreen,
      arguments: ListQuotationScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithQuotationItemScreen({
    _i40.Key? key,
    required List<_i42.Items> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.quotationItemScreen,
      arguments: QuotationItemScreenArguments(key: key, items: items),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHolidayScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.holidayScreen,
      arguments: HolidayScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAttendanceScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.attendanceScreen,
      arguments: AttendanceScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithExpenseScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.expenseScreen,
      arguments: ExpenseScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddExpenseScreen({
    _i40.Key? key,
    required String expenseId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addExpenseScreen,
      arguments: AddExpenseScreenArguments(key: key, expenseId: expenseId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListLeaveScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listLeaveScreen,
      arguments: ListLeaveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddLeaveScreen({
    _i40.Key? key,
    required String leaveId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addLeaveScreen,
      arguments: AddLeaveScreenArguments(key: key, leaveId: leaveId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithProfileScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.profileScreen,
      arguments: ProfileScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithChangePasswordScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.changePasswordScreen,
      arguments: ChangePasswordScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCustomerList({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.customerList,
      arguments: CustomerListArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddCustomer({
    _i40.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addCustomer,
      arguments: AddCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateCustomer({
    _i40.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateCustomer,
      arguments: UpdateCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithVisitScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.visitScreen,
      arguments: VisitScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddVisitScreen({
    _i40.Key? key,
    required String VisitId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addVisitScreen,
      arguments: AddVisitScreenArguments(key: key, VisitId: VisitId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateVisitScreen({
    _i40.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateVisitScreen,
      arguments: UpdateVisitScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithRetailerFormView({
    _i40.Key? key,
    required String retailerId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.retailerFormView,
      arguments: RetailerFormViewArguments(key: key, retailerId: retailerId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListDeliveryNoteScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listDeliveryNoteScreen,
      arguments: ListDeliveryNoteScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDeliveryNoteScreen({
    _i40.Key? key,
    required _i41.AddOrderModel orderData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.deliveryNoteScreen,
      arguments: DeliveryNoteScreenArguments(key: key, orderData: orderData),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListSelfOrderScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listSelfOrderScreen,
      arguments: ListSelfOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCreateSelfOrderScreen({
    _i40.Key? key,
    String orderId = "",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.createSelfOrderScreen,
      arguments: CreateSelfOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSalesIncentiveScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.salesIncentiveScreen,
      arguments: SalesIncentiveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLeaderboardScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.leaderboardScreen,
      arguments: LeaderboardScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithTerritorySummaryScreen({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.territorySummaryScreen,
      arguments: TerritorySummaryScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
