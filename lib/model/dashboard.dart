import 'package:geolocation/model/territory_summary_model.dart';
import 'package:geolocation/model/leaderboard_model.dart';

class DashBoard {
  String? inTime;
  String? outTime;
  String? lastLogType;
  String? lastLogTime;
  LastLocation? lastLocation;
  List<SalesPerson>? salesPerson;
  String? role;
  bool? trackingEnabled;
  List<String>? territorylist;
  String? empName;
  String? email;
  String? company;
  String? employeeImage;
  bool? isEmployee;

  // 🔥 NEW FIELDS
  Summary? summary;
  List<TerritorySummary>? territory;
  List<LeaderboardModel>? leaderboard;

  DashBoard({
    this.inTime,
    this.outTime,
    this.lastLogType,
    this.lastLogTime,
    this.lastLocation,
    this.salesPerson,
    this.role,
    this.trackingEnabled,
    this.territorylist,
    this.empName,
    this.email,
    this.company,
    this.employeeImage,
    this.isEmployee,
    this.summary,
    this.territory,
    this.leaderboard,
  });

  DashBoard.fromJson(Map<String, dynamic> json) {
    inTime = json['in_time'];
    outTime = json['out_time'];
    lastLogType = json['last_log_type'];
    lastLogTime = json['last_log_time'];

    lastLocation = json['last_location'] != null
        ? LastLocation.fromJson(json['last_location'])
        : null;

    if (json['sales_person'] != null) {
      salesPerson = <SalesPerson>[];
      json['sales_person'].forEach((v) {
        salesPerson!.add(SalesPerson.fromJson(v));
      });
    }

    role = json['role'];
    trackingEnabled = json['tracking_enabled'];
    territorylist = json['territorylist']?.cast<String>();
    empName = json['emp_name'];
    email = json['email'];
    company = json['company'];
    employeeImage = json['employee_image'];
    isEmployee = json['is_employee'];

    // 🔥 NEW SUMMARY
    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;

    // 🔥 TERRITORY
    territory = json['territory'] != null
        ? List.from(json['territory'])
        .map((e) => TerritorySummary.fromJson(e))
        .toList()
        : [];

    // 🔥 LEADERBOARD
    leaderboard = json['leaderboard'] != null
        ? List.from(json['leaderboard'])
        .map((e) => LeaderboardModel.fromJson(e))
        .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['in_time'] = inTime;
    data['out_time'] = outTime;
    data['last_log_type'] = lastLogType;
    data['last_log_time'] = lastLogTime;

    if (lastLocation != null) {
      data['last_location'] = lastLocation!.toJson();
    }

    if (salesPerson != null) {
      data['sales_person'] =
          salesPerson!.map((v) => v.toJson()).toList();
    }

    data['role'] = role;
    data['tracking_enabled'] = trackingEnabled;
    data['territorylist'] = territorylist;
    data['emp_name'] = empName;
    data['email'] = email;
    data['company'] = company;
    data['employee_image'] = employeeImage;
    data['is_employee'] = isEmployee;

    // 🔥 SAFE (NO toJson required)
    data['summary'] = summary;
    data['territory'] = territory;
    data['leaderboard'] = leaderboard;

    return data;
  }
}

class LastLocation {
  String? latitude;
  String? longitude;
  String? datetime;

  LastLocation({this.latitude, this.longitude, this.datetime});

  LastLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['datetime'] = this.datetime;
    return data;
  }
}

class SalesPerson {
  String? employee;
  String? employeeName;
  String? date;
  int? visitCount;
  int? tourCount;
  int? day;

  SalesPerson(
      {this.employee,
      this.employeeName,
      this.date,
      this.visitCount,
      this.tourCount,
      this.day});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    employee = json['employee'];
    employeeName = json['employee_name'];
    date = json['date'];
    visitCount = json['visit_count'];
    tourCount = json['tour_count'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee'] = this.employee;
    data['employee_name'] = this.employeeName;
    data['date'] = this.date;
    data['visit_count'] = this.visitCount;
    data['tour_count'] = this.tourCount;
    data['day'] = this.day;
    return data;
  }
}

class MonthlySummary {
  String? month;
  String? year;
  Visit? visit;
  Visit? attendance;
  Visit? leave;
  Visit? orders;
  Visit? leads;
  Visit? tours;

  MonthlySummary(
      {this.month,
      this.year,
      this.visit,
      this.attendance,
      this.leave,
      this.orders,
      this.tours,
      this.leads});

  MonthlySummary.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    visit = json['visit'] != null ? new Visit.fromJson(json['visit']) : null;
    attendance = json['attendance'] != null
        ? new Visit.fromJson(json['attendance'])
        : null;
    leave = json['leave'] != null ? new Visit.fromJson(json['leave']) : null;
    orders = json['orders'] != null ? new Visit.fromJson(json['orders']) : null;
    tours = json['tours'] != null ? new Visit.fromJson(json['tours']) : null;
    leads = json['leads'] != null ? new Visit.fromJson(json['leads']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    if (this.visit != null) {
      data['visit'] = this.visit!.toJson();
    }
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    if (this.leave != null) {
      data['leave'] = this.leave!.toJson();
    }
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    if (this.tours != null) {
      data['tours'] = this.tours!.toJson();
    }

    if (this.leads != null) {
      data['leads'] = this.leads!.toJson();
    }
    return data;
  }
}

class Visit {
  int? total;

  Visit({this.total});

  Visit.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}

class Summary {
  Visit? visit;
  Visit? attendance;
  Visit? leave;
  Visit? orders;
  Visit? leads;
  Visit? tours;

  Summary.fromJson(Map<String, dynamic> json) {
    visit = json['visit'] != null ? Visit.fromJson(json['visit']) : null;
    attendance = json['attendance'] != null ? Visit.fromJson(json['attendance']) : null;
    leave = json['leave'] != null ? Visit.fromJson(json['leave']) : null;
    orders = json['orders'] != null ? Visit.fromJson(json['orders']) : null;
    leads = json['leads'] != null ? Visit.fromJson(json['leads']) : null;
    tours = json['tours'] != null ? Visit.fromJson(json['tours']) : null;
  }
}
