class SalesIncentiveResponse {
  final int totalTarget;
  final int totalAchieved;
  final int incentive;
  final List<ProductProgress> products;

  SalesIncentiveResponse({
    required this.totalTarget,
    required this.totalAchieved,
    required this.incentive,
    required this.products,
  });

  factory SalesIncentiveResponse.fromJson(Map<String, dynamic> json) {
    return SalesIncentiveResponse(
      totalTarget: (json['total_target'] as num).toInt(),
      totalAchieved: (json['total_achieved'] as num).toInt(),
      incentive: (json['incentive'] as num).toInt(),
      products: (json['products'] as List)
          .map((e) => ProductProgress.fromJson(e))
          .toList(),
    );
  }
}

class ProductProgress {
  final String name;
  final int achieved;
  final int target;

  ProductProgress({
    required this.name,
    required this.achieved,
    required this.target,
  });

  factory ProductProgress.fromJson(Map<String, dynamic> json) {
    return ProductProgress(
      name: json['name'],
      achieved: (json['achieved'] as num).toInt(), // ✅ FIX
      target: (json['target'] as num).toInt(),
    );
  }

  double get progress => achieved / target;

  bool get isCompleted => achieved >= target;
}