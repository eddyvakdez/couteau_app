import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/gender_response.dart';
import '../widgets/loading_widget.dart';

class GenderPredictor extends StatefulWidget {
  const GenderPredictor({super.key});

  @override
  State<GenderPredictor> createState() => _GenderPredictorState();
}

class _GenderPredictorState extends State<GenderPredictor> {
  final TextEditingController _nameController = TextEditingController();
  GenderResponse? _genderData;
  bool _loading = false;
  String _error = '';

  Future<void> _predictGender() async {
    if (_nameController.text.isEmpty) {
      setState(() => _error = 'Por favor ingresa un nombre');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
      _genderData = null;
    });

    try {
      final response = await ApiService.predictGender(_nameController.text);
      setState(() => _genderData = response);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _getBackgroundColor() {
    if (_genderData?.gender == 'male') {
      return Colors.blue.shade100;
    } else if (_genderData?.gender == 'female') {
      return Colors.pink.shade100;
    }
    return Colors.grey.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de Género'),
        backgroundColor: _genderData?.gender == 'male' 
            ? Colors.blue 
            : _genderData?.gender == 'female' 
                ? Colors.pink 
                : Colors.grey,
      ),
      body: Container(
        color: _getBackgroundColor(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ingresa un nombre',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Juan, María',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _predictGender,
                child: const Text('Predecir Género'),
              ),
              const SizedBox(height: 16),
              
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              
              if (_loading) const LoadingWidget(),
              
              if (_genderData != null) _buildGenderResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Nombre: ${_genderData!.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Género: ${_genderData!.gender == 'male' ? 'Masculino' : 'Femenino'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Probabilidad: ${(_genderData!.probability * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}