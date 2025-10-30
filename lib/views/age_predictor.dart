import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/age_response.dart';
import '../widgets/loading_widget.dart';

class AgePredictor extends StatefulWidget {
  const AgePredictor({super.key});

  @override
  State<AgePredictor> createState() => _AgePredictorState();
}

class _AgePredictorState extends State<AgePredictor> {
  final TextEditingController _nameController = TextEditingController();
  AgeResponse? _ageData;
  bool _loading = false;
  String _error = '';

  Future<void> _predictAge() async {
    if (_nameController.text.isEmpty) {
      setState(() => _error = 'Por favor ingresa un nombre');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
      _ageData = null;
    });

    try {
      final response = await ApiService.predictAge(_nameController.text);
      setState(() => _ageData = response);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  String _getAgeCategory(int age) {
    if (age < 30) return 'Joven';
    if (age < 60) return 'Adulto';
    return 'Anciano';
  }

  String _getAgeImage(int age) {
    if (age < 30) return 'assets/images/joven.png';
    if (age < 60) return 'assets/images/adulto.png';
    return 'assets/images/anciano.png';
  }

  Color _getCategoryColor(int age) {
    if (age < 30) return Colors.green;
    if (age < 60) return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de Edad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa un nombre',
                border: OutlineInputBorder(),
                hintText: 'Ej: Carlos, Ana',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _predictAge,
              child: const Text('Predecir Edad'),
            ),
            const SizedBox(height: 16),
            
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            
            if (_loading) const LoadingWidget(),
            
            if (_ageData != null) _buildAgeResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeResult() {
    final ageCategory = _getAgeCategory(_ageData!.age);
    final categoryColor = _getCategoryColor(_ageData!.age);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Nombre: ${_ageData!.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Edad: ${_ageData!.age} años',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ageCategory,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              _getAgeImage(_ageData!.age),
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}