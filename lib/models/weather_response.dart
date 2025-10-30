class WeatherResponse {
  final String city;
  final String country;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;

  WeatherResponse({
    required this.city,
    required this.country,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return WeatherResponse(
      city: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (main['temp']?.toDouble() ?? 0) - 273.15, // Convertir de Kelvin a Celsius
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '',
      humidity: main['humidity']?.toDouble() ?? 0,
      windSpeed: wind['speed']?.toDouble() ?? 0,
    );
  }

  String getTemperatureString() {
    return '${temperature.toStringAsFixed(1)}°C';
  }

  String getHumidityString() {
    return '$humidity%';
  }

  String getWindSpeedString() {
    return '${windSpeed.toStringAsFixed(1)} m/s';
  }
}