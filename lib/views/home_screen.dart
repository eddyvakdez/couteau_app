import 'package:flutter/material.dart';
import 'gender_predictor.dart';
import 'age_predictor.dart';
import 'universities_view.dart';
import 'weather_view.dart';
import 'pokemon_view.dart';
import 'news_view.dart';
import 'about_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Couteau - Caja de Herramientas'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildToolCard(
                'Predicción de Género',
                Icons.person,
                Colors.pink,
                Colors.pink.shade50,
                () => _navigateTo(context, const GenderPredictor()),
              ),
              _buildToolCard(
                'Predicción de Edad',
                Icons.cake,
                Colors.orange,
                Colors.orange.shade50,
                () => _navigateTo(context, const AgePredictor()),
              ),
              _buildToolCard(
                'Universidades',
                Icons.school,
                Colors.green,
                Colors.green.shade50,
                () => _navigateTo(context, const UniversitiesView()),
              ),
              _buildToolCard(
                'Clima RD',
                Icons.cloud,
                Colors.lightBlue,
                Colors.lightBlue.shade50,
                () => _navigateTo(context, const WeatherView()),
              ),
              _buildToolCard(
                'Pokémon',
                Icons.catching_pokemon,
                Colors.red,
                Colors.red.shade50,
                () => _navigateTo(context, const PokemonView()),
              ),
              _buildToolCard(
                'Noticias',
                Icons.article,
                Colors.purple,
                Colors.purple.shade50,
                () => _navigateTo(context, const NewsView()),
              ),
              _buildToolCard(
                'Acerca de',
                Icons.info,
                Colors.teal,
                Colors.teal.shade50,
                () => _navigateTo(context, const AboutView()),
              ),
            ],
          ),
        ),
      ),
      // Footer con información de la app
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.blue.shade50,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 16, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Couteau v1.0.0 - Multiherramientas',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildToolCard(
    String title,
    IconData icon,
    Color color,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}