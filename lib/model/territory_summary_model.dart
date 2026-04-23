class TerritorySummary {
  final int rank;
  final String territory;
  final int active;
  final int nonActive;
  final int newCustomers;
  final int converted;
  final int leads;

  TerritorySummary({
    required this.rank,
    required this.territory,
    required this.active,
    required this.nonActive,
    required this.newCustomers,
    required this.converted,
    required this.leads,
  });

  factory TerritorySummary.fromJson(Map<String, dynamic> json) {
    return TerritorySummary(
      rank: json['rank'] ?? 0,
      territory: json['territory'] ?? '',
      active: json['active'] ?? 0,
      nonActive: json['non_active'] ?? 0,
      newCustomers: json['new'] ?? 0,
      converted: json['converted'] ?? 0,
      leads: json['leads'] ?? 0,
    );
  }
}