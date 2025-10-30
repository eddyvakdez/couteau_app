import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gender_response.dart';
import '../models/age_response.dart';
import '../models/university.dart';
import '../models/weather_response.dart';
import '../models/pokemon.dart';
import '../models/news_article.dart';
import '../config/api.config.dart';

class ApiService {
  // URLs base de las APIs
  static const String _genderApi = 'https://api.genderize.io';
  static const String _ageApi = 'https://api.agify.io';
  static const String _universitiesApi = 'http://universities.hipolabs.com/search';
    static const String _weatherApi = ApiConfig.weatherApi;

  static const String _pokemonApi = 'https://pokeapi.co/api/v2/pokemon';
  
  // API Key para OpenWeatherMap
  static const String _weatherApiKey = ApiConfig.weatherApiKey;

  // Métodos existentes (Gender, Age, Universities)...
  static Future<GenderResponse> predictGender(String name) async {
    final response = await http.get(Uri.parse('$_genderApi?name=$name'));
    
    if (response.statusCode == 200) {
      return GenderResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al predecir género: ${response.statusCode}');
    }
  }

  static Future<AgeResponse> predictAge(String name) async {
    final response = await http.get(Uri.parse('$_ageApi?name=$name'));
    
    if (response.statusCode == 200) {
      return AgeResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al predecir edad: ${response.statusCode}');
    }
  }

  static Future<List<University>> getUniversities(String country) async {
    final response = await http.get(
      Uri.parse('$_universitiesApi?country=${country.replaceAll(' ', '+')}')
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => University.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener universidades: ${response.statusCode}');
    }
  }

  // 🌤️ NUEVO: Método para obtener el clima en República Dominicana
  static Future<WeatherResponse> getWeatherInRD() async {
    // Usaremos Santo Domingo como ubicación por defecto
    const String city = 'Santo Domingo';
    const String countryCode = 'DO';
    
    final response = await http.get(
      Uri.parse('$_weatherApi?q=$city,$countryCode&appid=$_weatherApiKey')
    );
    
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el clima: ${response.statusCode}');
    }
  }

  // 🐲 NUEVO: Método para obtener información de Pokémon
  static Future<Pokemon> getPokemon(String pokemonName) async {
    final response = await http.get(
      Uri.parse('$_pokemonApi/${pokemonName.toLowerCase()}')
    );
    
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Pokémon no encontrado: $pokemonName');
    } else {
      throw Exception('Error al obtener Pokémon: ${response.statusCode}');
    }
  }

  // 📰 NUEVO: Método para obtener noticias de WordPress
  static Future<List<NewsArticle>> getWordPressNews() async {
    // Ejemplo de API de WordPress para noticias
    // Puedes cambiar esta URL por cualquier sitio WordPress que tenga REST API habilitado
    const String wordPressApiUrl = 'https://techcrunch.com/wp-json/wp/v2/posts';
    
    final response = await http.get(
      Uri.parse('$wordPressApiUrl?per_page=3&_embed')
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      // Si falla la API principal, usar datos de ejemplo
      return _getExampleNews();
    }
  }

  // Método de respaldo con noticias de ejemplo
  static List<NewsArticle> _getExampleNews() {
    return [
      NewsArticle(
        title: 'Flutter 3.0 Lanzado con Soporte Multiplataforma',
        summary: 'Google anuncia Flutter 3.0 con soporte estable para Windows, macOS y Linux.',
        content: 'Flutter 3.0 trae importantes mejoras en rendimiento y nuevas características...',
        imageUrl: 'assets/images/flutter_news.jpg',
        url: 'https://flutter.dev',
        publishedDate: DateTime.now(),
        author: 'Equipo Flutter',
      ),
      NewsArticle(
        title: 'Inteligencia Artificial Revoluciona el Desarrollo',
        summary: 'Las herramientas de IA están transformando la forma en que desarrollamos software.',
        content: 'GitHub Copilot y otras herramientas de IA están ayudando a los desarrolladores...',
        imageUrl: 'assets/images/ai_news.jpg',
        url: 'https://github.com',
        publishedDate: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Tech News',
      ),
      NewsArticle(
        title: 'Tendencias en Desarrollo Móvil 2024',
        summary: 'Descubre las principales tendencias en desarrollo de aplicaciones móviles.',
        content: 'El desarrollo multiplataforma continúa ganando popularidad...',
        imageUrl: 'assets/images/mobile_news.jpg',
        url: 'https://developer.android.com',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        author: 'Mobile Dev Journal',
      ),
    ];
  }

  // Método para manejar errores de red
  static void handleApiError(dynamic error) {
    if (error is http.ClientException) {
      throw Exception('Error de conexión: ${error.message}');
    } else {
      throw Exception('Error: $error');
    }
  }
}