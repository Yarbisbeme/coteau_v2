class AgeModel {
  final String name;
  final int? age; // Puede ser null si la API no conoce el nombre

  AgeModel({
    required this.name,
    this.age,
  });

  factory AgeModel.fromJson(Map<String, dynamic> json) {
    return AgeModel(
      name: json['name'] ?? '',
      age: json['age'], 
    );
  }
}