class GenderResponse {
  final String name;
  final String gender;
  final double probability;
  final int count;

  GenderResponse({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  factory GenderResponse.fromJson(Map<String, dynamic> json) {
    return GenderResponse(
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      probability: json['probability']?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }
}