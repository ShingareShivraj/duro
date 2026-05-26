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

class LeaderboardModel {
  final int rank;
  final String salesPerson;
  final double totalSales;
  final int orders;
  final int visits;
  final double? percentage;
  final String? trend;
  final double? currentMonthSales;
  final double? fullLastMonthSales;

  final double? currentYearSales;
  final double? fullLastYearSales;

  final double? currentDaySales;
  final double? fullLastDaySales;

  LeaderboardModel({
    required this.rank,
    required this.salesPerson,
    required this.totalSales,
    required this.orders,
    required this.visits,
    required this.percentage,
    required this.trend,
    this.currentMonthSales,
    this.fullLastMonthSales,

    this.currentYearSales,
    this.fullLastYearSales,

    this.currentDaySales,
    this.fullLastDaySales,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] ?? 0,
      salesPerson: json['sales_person'] ?? '',
      totalSales: (json['total_sales'] ?? 0).toDouble(),
      orders: json['orders'] ?? 0,
      visits: json['visits'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      trend: (json['trend'] ?? "neutral").toString().toLowerCase(),

      currentMonthSales:
      (json['current_month_sales'] ?? 0).toDouble(),

      fullLastMonthSales:
      (json['full_last_month_sales'] ?? 0).toDouble(),

      currentYearSales:
      (json['current_year_sales'] ?? 0).toDouble(),

      fullLastYearSales:
      (json['full_last_year_sales'] ?? 0).toDouble(),

      currentDaySales:
      (json['current_day_sales'] ?? 0).toDouble(),

      fullLastDaySales:
      (json['full_last_day_sales'] ?? 0).toDouble(),
    );
  }
}