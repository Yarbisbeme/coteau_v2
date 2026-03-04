class PokemonModel {
  final String name;
  final String imageUrl;
  final int baseExperience;
  final double height; // Viene en decímetros
  final double weight; // Viene en hectogramos
  final List<String> types;
  final List<String> abilities;
  final String cryUrl;

  PokemonModel({
    required this.name,
    required this.imageUrl,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.cryUrl,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    // Extraer tipos
    var typesList = json['types'] as List;
    List<String> types = typesList.map((t) => t['type']['name'].toString()).toList();

    // Extraer habilidades
    var abilitiesList = json['abilities'] as List;
    List<String> abilities = abilitiesList.map((a) => a['ability']['name'].toString()).toList();

    // TRUCO DE QA: Usamos el 'official-artwork' porque el sprite normal es muy pixelado
    String imageUrl = json['sprites']['other']['official-artwork']['front_default'] ?? 
                      json['sprites']['front_default'] ?? '';

    return PokemonModel(
      name: json['name'],
      imageUrl: imageUrl,
      baseExperience: json['base_experience'] ?? 0,
      height: (json['height'] ?? 0) / 10.0, // Convertimos a Metros
      weight: (json['weight'] ?? 0) / 10.0, // Convertimos a KG
      types: types,
      abilities: abilities,
      cryUrl: json['cries']['latest'] ?? '',
    );
  }
}