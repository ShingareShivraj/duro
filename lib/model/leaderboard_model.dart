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

  LeaderboardModel({
    required this.rank,
    required this.salesPerson,
    required this.totalSales,
    required this.orders,
    required this.visits,
    required this.percentage,
    required this.trend,
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
    );
  }
}