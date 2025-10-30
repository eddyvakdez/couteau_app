class AgeResponse {
  final String name;
  final int age;
  final int count;

  AgeResponse({
    required this.name,
    required this.age,
    required this.count,
  });

  factory AgeResponse.fromJson(Map<String, dynamic> json) {
    return AgeResponse(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}