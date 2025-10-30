class Pokemon {
  final String name;
  final int id;
  final int baseExperience;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> abilities;
  final List<String> types;
  final String crySoundUrl;

  Pokemon({
    required this.name,
    required this.id,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.abilities,
    required this.types,
    required this.crySoundUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Obtener habilidades
    final abilitiesList = (json['abilities'] as List)
        .map((ability) => ability['ability']['name'] as String)
        .toList();

    // Obtener tipos
    final typesList = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    // Construir URL de la imagen oficial
    final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${json['id']}.png';

    // URL del sonido (usando la API de PokeAPI para cries)
    final String crySoundUrl = 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/${json['id']}.ogg';

    return Pokemon(
      name: (json['name'] as String).toUpperCase(),
      id: json['id'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      imageUrl: imageUrl,
      abilities: abilitiesList,
      types: typesList,
      crySoundUrl: crySoundUrl,
    );
  }

  String getFormattedName() {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  String getHeightString() {
    return '${height / 10} m';
  }

  String getWeightString() {
    return '${weight / 10} kg';
  }
}