// class LeaderboardModel {
//   final String salesPerson;
//   final double totalSales;
//   final int orders;
//   final int visits;
//
//   LeaderboardModel({
//     required this.salesPerson,
//     required this.totalSales,
//     required this.orders,
//     required this.visits,
//   });
//
//   factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
//     return LeaderboardModel(
//       salesPerson: json['sales_person'] ?? '',
//       totalSales: (json['total_sales'] ?? 0).toDouble(),
//       orders: json['orders'] ?? 0,
//       visits: json['visits'] ?? 0,
//     );
//   }
// }

// class LeaderboardModel {
//   final int rank;
//   final String salesPerson;
//   final double totalSales;
//   final int orders;
//   final int visits;
//   final double? percentage;
//   final String? trend;
//   final double? currentMonthSales;
//   final double? fullLastMonthSales;
//
//   final double? currentYearSales;
//   final double? fullLastYearSales;
//
//   final double? currentDaySales;
//   final double? fullLastDaySales;
//
//   LeaderboardModel({
//     required this.rank,
//     required this.salesPerson,
//     required this.totalSales,
//     required this.orders,
//     required this.visits,
//     required this.percentage,
//     required this.trend,
//     this.currentMonthSales,
//     this.fullLastMonthSales,
//
//     this.currentYearSales,
//     this.fullLastYearSales,
//
//     this.currentDaySales,
//     this.fullLastDaySales,
//   });
//
//   factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
//     return LeaderboardModel(
//       rank: json['rank'] ?? 0,
//       salesPerson: json['sales_person'] ?? '',
//       totalSales: (json['total_sales'] ?? 0).toDouble(),
//       orders: json['orders'] ?? 0,
//       visits: json['visits'] ?? 0,
//       percentage: (json['percentage'] ?? 0).toDouble(),
//       trend: (json['trend'] ?? "neutral").toString().toLowerCase(),
//
//       currentMonthSales:
//       (json['current_month_sales'] ?? 0).toDouble(),
//
//       fullLastMonthSales:
//       (json['full_last_month_sales'] ?? 0).toDouble(),
//
//       currentYearSales:
//       (json['current_year_sales'] ?? 0).toDouble(),
//
//       fullLastYearSales:
//       (json['full_last_year_sales'] ?? 0).toDouble(),
//
//       currentDaySales:
//       (json['current_day_sales'] ?? 0).toDouble(),
//
//       fullLastDaySales:
//       (json['full_last_day_sales'] ?? 0).toDouble(),
//     );
//   }
// }

class LeaderboardModel {
  final int rank;

  final String salesPerson;

  final double totalSales;

  final int orders;

  final int visits;

  final Comparison comparison;

  final Sales sales;

  LeaderboardModel({
    required this.rank,
    required this.salesPerson,
    required this.totalSales,
    required this.orders,
    required this.visits,
    required this.comparison,
    required this.sales,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] ?? 0,

      salesPerson: json['sales_person'] ?? '',

      totalSales: (json['total_sales'] ?? 0).toDouble(),

      orders: json['orders'] ?? 0,

      visits: json['visits'] ?? 0,

      comparison: Comparison.fromJson(
        json['comparison'] ?? {},
      ),

      sales: Sales.fromJson(
        json['sales'] ?? {},
      ),
    );
  }
}

class Comparison {
  final double previousSales;

  final double difference;

  final double percentage;

  final String trend;

  Comparison({
    required this.previousSales,
    required this.difference,
    required this.percentage,
    required this.trend,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) {
    return Comparison(
      previousSales:
      (json['previous_sales'] ?? 0).toDouble(),

      difference:
      (json['difference'] ?? 0).toDouble(),

      percentage:
      (json['percentage'] ?? 0).toDouble(),

      trend: (json['trend'] ?? 'neutral')
          .toString()
          .toLowerCase(),
    );
  }
}

class Sales {
  final SalesPeriod fiscal;

  final SalesPeriod monthly;

  final SalesPeriod daily;

  Sales({
    required this.fiscal,
    required this.monthly,
    required this.daily,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      fiscal: SalesPeriod.fromJson(
        json['fiscal'] ?? {},
      ),

      monthly: SalesPeriod.fromJson(
        json['monthly'] ?? {},
      ),

      daily: SalesPeriod.fromJson(
        json['daily'] ?? {},
      ),
    );
  }
}

class SalesPeriod {
  final String currentLabel;

  final String previousLabel;

  final double current;

  final double previous;

  SalesPeriod({
    required this.currentLabel,
    required this.previousLabel,
    required this.current,
    required this.previous,
  });

  factory SalesPeriod.fromJson(Map<String, dynamic> json) {
    return SalesPeriod(
      currentLabel: json['current_label'] ?? '',

      previousLabel: json['previous_label'] ?? '',

      current: (json['current'] ?? 0).toDouble(),

      previous: (json['previous'] ?? 0).toDouble(),
    );
  }
}