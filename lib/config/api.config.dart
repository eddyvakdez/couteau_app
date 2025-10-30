class ApiConfig {
  // API Key para OpenWeatherMap (OBTÉN UNA GRATIS EN: https://openweathermap.org/api)
  static const String weatherApiKey = 'ee89a785fbebe6810e954fcb2c89093d';
  
  // URLs de APIs
  static const String genderApi = 'https://api.genderize.io';
  static const String ageApi = 'https://api.agify.io';
  static const String universitiesApi = 'http://universities.hipolabs.com/search';
  static const String weatherApi = 'https://api.openweathermap.org/data/2.5/weather';
  static const String pokemonApi = 'https://pokeapi.co/api/v2/pokemon';
  static const String wordPressNewsApi = 'https://techcrunch.com/wp-json/wp/v2/posts';
  
  // URLs alternativas para noticias (puedes usar cualquiera)
  static const List<String> newsApis = [
    'https://techcrunch.com/wp-json/wp/v2/posts',
    'https://www.smashingmagazine.com/wp-json/wp/v2/posts',
    'https://css-tricks.com/wp-json/wp/v2/posts',
  ];
}

class AppConfig {
  static const String appName = 'Couteau';
  static const String version = '1.0.0';
  static const String developer = 'Tu Nombre';
}