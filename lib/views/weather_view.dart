import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/weather_response.dart';
import '../widgets/loading_widget.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  WeatherResponse? _weatherData;
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await ApiService.getWeatherInRD();
      setState(() => _weatherData = response);
    } catch (e) {
      setState(() => _error = 'Error al cargar el clima: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildWeatherIcon(String iconCode) {
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@2x.png',
      width: 80,
      height: 80,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 60),
    );
  }

  Widget _buildWeatherCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en República Dominicana'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeather,
          ),
        ],
      ),
      body: _loading
          ? const LoadingWidget()
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _weatherData != null
                  ? _buildWeatherContent()
                  : const Center(child: Text('No hay datos del clima')),
    );
  }

  Widget _buildWeatherContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header con ciudad y temperatura
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    _weatherData!.city,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'República Dominicana',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWeatherIcon(_weatherData!.icon),
                      const SizedBox(width: 16),
                      Text(
                        _weatherData!.getTemperatureString(),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _weatherData!.description.toUpperCase(),
                    style: const TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Estadísticas del clima
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildWeatherCard('HUMEDAD', _weatherData!.getHumidityString(), Icons.water_drop),
              _buildWeatherCard('VIENTO', _weatherData!.getWindSpeedString(), Icons.air),
              _buildWeatherCard('SENSACIÓN', _weatherData!.getTemperatureString(), Icons.thermostat),
              _buildWeatherCard('PAÍS', _weatherData!.country, Icons.flag),
            ],
          ),
          const SizedBox(height: 20),
          // Información adicional
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Clima',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Actualizado', DateTime.now().toString().substring(0, 16)),
                  _buildInfoRow('Condición', _weatherData!.description),
                  _buildInfoRow('Temperatura', _weatherData!.getTemperatureString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}