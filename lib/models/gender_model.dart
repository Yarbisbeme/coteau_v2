class GenderModel {

  final String name;
  final String? gender;
  final double? probability;
  final int? count;

  GenderModel({
    required this.name,
    this.gender,
    this.probability,
    this.count,
  });

  // factory para convertir el JSON a objeto
  factory GenderModel.fromJson(Map<String, dynamic> json) {
    return GenderModel(
      name: json['name'],
      gender: json['gender'],
      probability: (json['probability'] as num?)?.toDouble(),
      count: json['count'],
    );
  }
}