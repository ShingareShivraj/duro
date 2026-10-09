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



class CommissionDashboard {
  final CommissionLoggedInUser? loggedInUser;
  final String role;
  final bool isSalesManager;
  final CommissionSalesPerson? selectedSalesPerson;
  final List<CommissionSalesPerson> salesPersons;
  final CommissionPeriod? period;
  final String currency;
  final CommissionSummary? summary;
  final List<CommissionMilestone> milestones;
  final CommissionNextGoal? nextGoal;
  final CustomerOpportunitySummary customerOpportunitySummary;
  final List<CustomerCommissionOpportunity> customerOpportunities;
  final List<CommissionWeek> weeks;

  const CommissionDashboard({
    this.loggedInUser,
    required this.role,
    required this.isSalesManager,
    this.selectedSalesPerson,
    required this.salesPersons,
    this.period,
    required this.currency,
    this.summary,
    required this.milestones,
    this.nextGoal,
    required this.customerOpportunitySummary,
    required this.customerOpportunities,
    required this.weeks,
  });

  factory CommissionDashboard.fromJson(Map<String, dynamic> json) {
    return CommissionDashboard(
      loggedInUser: json['logged_in_user'] is Map
          ? CommissionLoggedInUser.fromJson(
        Map<String, dynamic>.from(json['logged_in_user']),
      )
          : null,
      role: json['role']?.toString() ?? 'sales_person',
      isSalesManager: _commissionBool(json['is_sales_manager']),
      selectedSalesPerson: json['selected_sales_person'] is Map
          ? CommissionSalesPerson.fromJson(
        Map<String, dynamic>.from(json['selected_sales_person']),
      )
          : null,
      salesPersons: _commissionList(
        json['sales_persons'],
        CommissionSalesPerson.fromJson,
      ),
      period: json['period'] is Map
          ? CommissionPeriod.fromJson(
        Map<String, dynamic>.from(json['period']),
      )
          : null,
      currency: json['currency']?.toString() ?? 'INR',
      summary: json['summary'] is Map
          ? CommissionSummary.fromJson(
        Map<String, dynamic>.from(json['summary']),
      )
          : null,
      milestones: _commissionList(
        json['milestones'],
        CommissionMilestone.fromJson,
      ),
      nextGoal: json['next_goal'] is Map
          ? CommissionNextGoal.fromJson(
        Map<String, dynamic>.from(json['next_goal']),
      )
          : null,
      customerOpportunitySummary:
      json['customer_opportunity_summary'] is Map
          ? CustomerOpportunitySummary.fromJson(
        Map<String, dynamic>.from(
          json['customer_opportunity_summary'],
        ),
      )
          : const CustomerOpportunitySummary.empty(),
      customerOpportunities: _commissionList(
        json['customer_opportunities'],
        CustomerCommissionOpportunity.fromJson,
      ),
      weeks: _commissionList(
        json['weeks'],
        CommissionWeek.fromJson,
      ),
    );
  }

  bool get hasCustomerOpportunities =>
      customerOpportunities.isNotEmpty;

  String get customerOpportunityEmptyMessage {
    if (isSalesManager) {
      final personName =
          selectedSalesPerson?.displayName ?? 'This salesperson';

      return '$personName has no new or reactivated customer '
          'commission opportunity for this month.';
    }

    return 'Create a new customer or reactivate an inactive '
        'customer, make the required sale and earn additional '
        'commission.';
  }
}

class CommissionLoggedInUser {
  final String? employee;
  final String? employeeName;
  final String? user;
  final String? company;

  const CommissionLoggedInUser({
    this.employee,
    this.employeeName,
    this.user,
    this.company,
  });

  factory CommissionLoggedInUser.fromJson(Map<String, dynamic> json) {
    return CommissionLoggedInUser(
      employee: json['employee']?.toString(),
      employeeName: json['employee_name']?.toString(),
      user: json['user']?.toString(),
      company: json['company']?.toString(),
    );
  }
}

class CommissionSalesPerson {
  final String name;
  final String? employee;
  final String? employeeName;

  const CommissionSalesPerson({
    required this.name,
    this.employee,
    this.employeeName,
  });

  factory CommissionSalesPerson.fromJson(Map<String, dynamic> json) {
    return CommissionSalesPerson(
      name: json['name']?.toString() ?? '',
      employee: json['employee']?.toString(),
      employeeName: json['employee_name']?.toString(),
    );
  }

  String get displayName {
    final value = employeeName?.trim();

    if (value != null && value.isNotEmpty) {
      return value;
    }

    return name;
  }
}

class CommissionPeriod {
  final String? fromDate;
  final String? toDate;
  final String month;
  final String? monthValue;

  const CommissionPeriod({
    this.fromDate,
    this.toDate,
    required this.month,
    this.monthValue,
  });

  factory CommissionPeriod.fromJson(Map<String, dynamic> json) {
    return CommissionPeriod(
      fromDate: json['from_date']?.toString(),
      toDate: json['to_date']?.toString(),
      month: json['month']?.toString() ?? '',
      monthValue: json['month_value']?.toString(),
    );
  }
}

class CommissionSummary {
  final double monthlyTarget;
  final double totalSales;
  final double achievementPercent;
  final double weeklyCommissionPercent;
  final double slabCommissionPercent;
  final double weeklyCommission;
  final double targetCommission;
  final double newCustomerCommission;
  final double inactiveToActiveCommission;
  final double totalCommission;
  final String commissionStatus;
  final double targetRemaining;
  final bool targetAchieved;

  const CommissionSummary({
    required this.monthlyTarget,
    required this.totalSales,
    required this.achievementPercent,
    required this.weeklyCommissionPercent,
    required this.slabCommissionPercent,
    required this.weeklyCommission,
    required this.targetCommission,
    required this.newCustomerCommission,
    required this.inactiveToActiveCommission,
    required this.totalCommission,
    required this.commissionStatus,
    required this.targetRemaining,
    required this.targetAchieved,
  });

  factory CommissionSummary.fromJson(Map<String, dynamic> json) {
    return CommissionSummary(
      monthlyTarget: _commissionDouble(json['monthly_target']),
      totalSales: _commissionDouble(json['total_sales']),
      achievementPercent:
      _commissionDouble(json['achievement_percent']),
      weeklyCommissionPercent:
      _commissionDouble(json['weekly_commission_percent']),
      slabCommissionPercent:
      _commissionDouble(json['slab_commission_percent']),
      weeklyCommission:
      _commissionDouble(json['weekly_commission']),
      targetCommission:
      _commissionDouble(json['target_commission']),
      newCustomerCommission:
      _commissionDouble(json['new_customer_commission']),
      inactiveToActiveCommission:
      _commissionDouble(
        json['inactive_to_active_commission'],
      ),
      totalCommission:
      _commissionDouble(json['total_commission']),
      commissionStatus:
      json['commission_status']?.toString() ?? 'Nil',
      targetRemaining:
      _commissionDouble(json['target_remaining']),
      targetAchieved:
      _commissionBool(json['target_achieved']),
    );
  }

  double get progress {
    if (monthlyTarget <= 0) {
      return 0;
    }

    return (totalSales / monthlyTarget).clamp(0.0, 1.0);
  }
}

class CommissionMilestone {
  final double fromTargetPercent;
  final double toTargetPercent;
  final double targetSales;
  final double commissionPercent;
  final bool isReached;
  final bool isCurrent;

  const CommissionMilestone({
    required this.fromTargetPercent,
    required this.toTargetPercent,
    required this.targetSales,
    required this.commissionPercent,
    required this.isReached,
    required this.isCurrent,
  });

  factory CommissionMilestone.fromJson(Map<String, dynamic> json) {
    return CommissionMilestone(
      fromTargetPercent:
      _commissionDouble(json['from_target_percent']),
      toTargetPercent:
      _commissionDouble(json['to_target_percent']),
      targetSales: _commissionDouble(json['target_sales']),
      commissionPercent:
      _commissionDouble(json['commission_percent']),
      isReached: _commissionBool(json['is_reached']),
      isCurrent: _commissionBool(json['is_current']),
    );
  }
}

class CommissionNextGoal {
  final double targetPercent;
  final double targetSales;
  final double remainingSales;
  final double commissionPercent;

  const CommissionNextGoal({
    required this.targetPercent,
    required this.targetSales,
    required this.remainingSales,
    required this.commissionPercent,
  });

  factory CommissionNextGoal.fromJson(Map<String, dynamic> json) {
    return CommissionNextGoal(
      targetPercent: _commissionDouble(json['target_percent']),
      targetSales: _commissionDouble(json['target_sales']),
      remainingSales: _commissionDouble(json['remaining_sales']),
      commissionPercent:
      _commissionDouble(json['commission_percent']),
    );
  }
}


class CustomerOpportunitySummary {
  final bool visible;
  final int totalCustomers;
  final int inProgressCustomers;
  final int earnedCustomers;
  final int newCustomers;
  final int reactivatedCustomers;
  final double potentialCommission;
  final double pendingCommission;
  final double earnedCommission;

  const CustomerOpportunitySummary({
    required this.visible,
    required this.totalCustomers,
    required this.inProgressCustomers,
    required this.earnedCustomers,
    required this.newCustomers,
    required this.reactivatedCustomers,
    required this.potentialCommission,
    required this.pendingCommission,
    required this.earnedCommission,
  });

  const CustomerOpportunitySummary.empty()
      : visible = false,
        totalCustomers = 0,
        inProgressCustomers = 0,
        earnedCustomers = 0,
        newCustomers = 0,
        reactivatedCustomers = 0,
        potentialCommission = 0,
        pendingCommission = 0,
        earnedCommission = 0;

  factory CustomerOpportunitySummary.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerOpportunitySummary(
      visible: _commissionBool(json['visible']),
      totalCustomers:
      _commissionInt(json['total_customers']),
      inProgressCustomers:
      _commissionInt(json['in_progress_customers']),
      earnedCustomers:
      _commissionInt(json['earned_customers']),
      newCustomers:
      _commissionInt(json['new_customers']),
      reactivatedCustomers:
      _commissionInt(json['reactivated_customers']),
      potentialCommission:
      _commissionDouble(json['potential_commission']),
      pendingCommission:
      _commissionDouble(json['pending_commission']),
      earnedCommission:
      _commissionDouble(json['earned_commission']),
    );
  }
}

class CustomerCommissionOpportunity {
  final String customer;
  final String customerName;
  final String customerStatus;
  final String opportunityType;
  final String status;
  final bool isEarned;
  final bool canStillEarn;
  final double currentSales;
  final double minimumPurchaseAmount;
  final double remainingSales;
  final double commissionAmount;
  final double progressPercent;
  final String? firstSaleDate;
  final String? lastSaleDate;
  final String? customerCreatedOn;
  final String? previousPurchaseDate;
  final int invoiceCount;
  final String? deadline;
  final int daysRemaining;

  const CustomerCommissionOpportunity({
    required this.customer,
    required this.customerName,
    required this.customerStatus,
    required this.opportunityType,
    required this.status,
    required this.isEarned,
    required this.canStillEarn,
    required this.currentSales,
    required this.minimumPurchaseAmount,
    required this.remainingSales,
    required this.commissionAmount,
    required this.progressPercent,
    this.firstSaleDate,
    this.lastSaleDate,
    this.customerCreatedOn,
    this.previousPurchaseDate,
    required this.invoiceCount,
    this.deadline,
    required this.daysRemaining,
  });

  factory CustomerCommissionOpportunity.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerCommissionOpportunity(
      customer: json['customer']?.toString() ?? '',
      customerName:
      json['customer_name']?.toString() ?? '',
      customerStatus:
      json['customer_status']?.toString() ?? '',
      opportunityType:
      json['opportunity_type']?.toString() ?? '',
      status: json['status']?.toString() ?? 'In Progress',
      isEarned: _commissionBool(json['is_earned']),
      canStillEarn:
      _commissionBool(json['can_still_earn']),
      currentSales:
      _commissionDouble(json['current_sales']),
      minimumPurchaseAmount: _commissionDouble(
        json['minimum_purchase_amount'],
      ),
      remainingSales:
      _commissionDouble(json['remaining_sales']),
      commissionAmount:
      _commissionDouble(json['commission_amount']),
      progressPercent:
      _commissionDouble(json['progress_percent']),
      firstSaleDate: json['first_sale_date']?.toString(),
      lastSaleDate: json['last_sale_date']?.toString(),
      customerCreatedOn:
      json['customer_created_on']?.toString(),
      previousPurchaseDate:
      json['previous_purchase_date']?.toString(),
      invoiceCount:
      _commissionInt(json['invoice_count']),
      deadline: json['deadline']?.toString(),
      daysRemaining:
      _commissionInt(json['days_remaining']),
    );
  }

  bool get isNewCustomer =>
      opportunityType == 'new_customer';

  bool get isReactivatedCustomer =>
      opportunityType == 'reactivated_customer';

  double get progress =>
      (progressPercent / 100).clamp(0.0, 1.0);

  String get typeLabel {
    if (isNewCustomer) {
      return 'New Customer';
    }

    if (isReactivatedCustomer) {
      return 'Reactivated Customer';
    }

    return customerStatus;
  }
}



class CommissionWeek {
  final int week;
  final String? fromDate;
  final String? toDate;
  final double sales;
  final double commissionPercent;
  final double commission;
  final String status;
  final bool isCompleted;
  final bool isCurrent;

  const CommissionWeek({
    required this.week,
    this.fromDate,
    this.toDate,
    required this.sales,
    required this.commissionPercent,
    required this.commission,
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
  });

  factory CommissionWeek.fromJson(Map<String, dynamic> json) {
    return CommissionWeek(
      week: _commissionInt(json['week']),
      fromDate: json['from_date']?.toString(),
      toDate: json['to_date']?.toString(),
      sales: _commissionDouble(json['sales']),
      commissionPercent:
      _commissionDouble(json['commission_percent']),
      commission: _commissionDouble(json['commission']),
      status: json['status']?.toString() ?? 'Nil',
      isCompleted: _commissionBool(json['is_completed']),
      isCurrent: _commissionBool(json['is_current']),
    );
  }
}

double _commissionDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _commissionInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _commissionBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();

  return normalized == 'true' ||
      normalized == '1' ||
      normalized == 'yes';
}

List<T> _commissionList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
    ) {
  if (value is! List) {
    return <T>[];
  }

  return value
      .whereType<Map>()
      .map(
        (item) => fromJson(
      Map<String, dynamic>.from(item),
    ),
  )
      .toList();
}