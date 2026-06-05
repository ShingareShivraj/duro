class SalesIncentiveResponse {
  final int totalTarget;
  final int totalAchieved;
  final double incentive; // ✅ FIX TYPE
  final List<ProductProgress> products;
  final String monthLabel;
  final String fyLabel;

  SalesIncentiveResponse({
    required this.totalTarget,
    required this.totalAchieved,
    required this.incentive,
    required this.products,
    required this.monthLabel,
    required this.fyLabel,
  });

  factory SalesIncentiveResponse.fromJson(Map<String, dynamic> json) {
    return SalesIncentiveResponse(
      totalTarget: (json['total_target'] as num).toInt(),
      totalAchieved: (json['total_achieved'] as num).toInt(),
      incentive: (json['incentive'] as num).toDouble(), // ✅ FIX
      products: (json['products'] as List)
          .map((e) => ProductProgress.fromJson(e))
          .toList(),

      monthLabel: json["month_label"] ?? "Month",
      fyLabel: json["fy_label"] ?? "FY",
    );
  }
}

class ProductProgress {
  final String name;
  final int achieved;
  final int target;
  final double incentive; // ✅ ADD THIS

  ProductProgress({
    required this.name,
    required this.achieved,
    required this.target,
    required this.incentive,
  });

  factory ProductProgress.fromJson(Map<String, dynamic> json) {
    return ProductProgress(
      name: json['name'],
      achieved: (json['achieved'] as num).toInt(),
      target: (json['target'] as num).toInt(),
      incentive: (json['incentive'] as num).toDouble(), // ✅ ADD
    );
  }

  double get progress => target == 0 ? 0 : achieved / target; // ✅ FIX

  bool get isCompleted => achieved >= target;
}