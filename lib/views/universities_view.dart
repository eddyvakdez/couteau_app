import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/university.dart';
import '../widgets/loading_widget.dart';

class UniversitiesView extends StatefulWidget {
  const UniversitiesView({super.key});

  @override
  State<UniversitiesView> createState() => _UniversitiesViewState();
}

class _UniversitiesViewState extends State<UniversitiesView> {
  final TextEditingController _countryController = TextEditingController();
  List<University> _universities = [];
  bool _loading = false;
  String _error = '';

  Future<void> _searchUniversities() async {
    if (_countryController.text.isEmpty) {
      setState(() => _error = 'Por favor ingresa un país');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
      _universities = [];
    });

    try {
      final response = await ApiService.getUniversities(_countryController.text);
      setState(() => _universities = response);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por País')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Ingresa un país (en inglés)',
                border: OutlineInputBorder(),
                hintText: 'Ej: Dominican Republic, United States',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchUniversities,
              child: const Text('Buscar Universidades'),
            ),
            const SizedBox(height: 16),
            
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            
            if (_loading) const LoadingWidget(),
            
            if (_universities.isNotEmpty) _buildUniversitiesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversitiesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _universities.length,
        itemBuilder: (context, index) {
          final university = _universities[index];
          return Card(
            child: ListTile(
              title: Text(university.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (university.domain.isNotEmpty)
                    Text('Dominio: ${university.domain}'),
                  if (university.website.isNotEmpty)
                    Text('Sitio web: ${university.website}'),
                ],
              ),
              trailing: university.website.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () {
                        // Aquí podrías abrir el enlace en el navegador
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}