class UniversityModel {
  final String name;
  final String domain;
  final String webPage;
  final String country;

  UniversityModel({
    required this.name,
    required this.domain,
    required this.webPage,
    required this.country,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    // Las URLs y dominios vienen en listas (arrays), tomamos el primero
    List<dynamic> domains = json['domains'] ?? [];
    List<dynamic> webPages = json['web_pages'] ?? [];

    return UniversityModel(
      name: json['name'] ?? 'Unknown',
      domain: domains.isNotEmpty ? domains[0].toString() : 'No domain',
      webPage: webPages.isNotEmpty ? webPages[0].toString() : '',
      country: json['country'] ?? 'Unknown',
    );
  }
}