import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';
import '../widgets/loading_widget.dart';
import '../widgets/network_image_widget.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController _pokemonController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Pokemon? _pokemonData;
  bool _loading = false;
  String _error = '';
  bool _isPlaying = false;

  Future<void> _searchPokemon() async {
    if (_pokemonController.text.isEmpty) {
      setState(() => _error = 'Por favor ingresa el nombre de un Pokémon');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
      _pokemonData = null;
    });

    try {
      final response = await ApiService.getPokemon(_pokemonController.text);
      setState(() => _pokemonData = response);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _playPokemonCry() async {
    if (_pokemonData == null) return;

    setState(() => _isPlaying = true);
    try {
      await _audioPlayer.play(UrlSource(_pokemonData!.crySoundUrl));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al reproducir sonido')),
      );
    } finally {
      setState(() => _isPlaying = false);
    }
  }

  Color _getTypeColor(String type) {
    final colors = {
      'fire': Colors.orange,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'psychic': Colors.purple,
      'ice': Colors.lightBlue,
      'dragon': Colors.indigo,
      'dark': Colors.brown,
      'fairy': Colors.pink,
      'normal': Colors.grey,
      'fighting': Colors.red,
      'flying': Colors.lightBlue,
      'poison': Colors.purple,
      'ground': Colors.orange,
      'rock': Colors.brown,
      'bug': Colors.lightGreen,
      'ghost': Colors.deepPurple,
      'steel': Colors.blueGrey,
    };
    return colors[type] ?? Colors.grey;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Pokémon'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pokemonController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Pokémon',
                      border: OutlineInputBorder(),
                      hintText: 'Ej: pikachu, charizard, bulbasaur',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchPokemon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_error.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_error)),
                  ],
                ),
              ),
            
            if (_loading) const LoadingWidget(),
            
            if (_pokemonData != null) _buildPokemonDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header con imagen y nombre
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _pokemonData!.getFormattedName(),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '#${_pokemonData!.id.toString().padLeft(3, '0')}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        NetworkImageWidget(
                          imageUrl: _pokemonData!.imageUrl,
                          width: 200,
                          height: 200,
                          placeholder: const CircularProgressIndicator(),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: _isPlaying ? null : _playPokemonCry,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Estadísticas básicas
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildStatCard('Experiencia', _pokemonData!.baseExperience.toString()),
                _buildStatCard('Altura', _pokemonData!.getHeightString()),
                _buildStatCard('Peso', _pokemonData!.getWeightString()),
              ],
            ),
            const SizedBox(height: 16),
            // Tipos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _pokemonData!.types.map((type) {
                        return Chip(
                          label: Text(
                            type.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getTypeColor(type),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Habilidades
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Habilidades',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: _pokemonData!.abilities.map((ability) {
                        return ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(
                            ability[0].toUpperCase() + ability.substring(1),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}