class University {
  final String name;
  final String domain;
  final String website;

  University({
    required this.name,
    required this.domain,
    required this.website,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] ?? '',
      domain: json['domains'] != null && json['domains'].isNotEmpty 
          ? json['domains'][0] 
          : '',
      website: json['web_pages'] != null && json['web_pages'].isNotEmpty 
          ? json['web_pages'][0] 
          : '',
    );
  }
}