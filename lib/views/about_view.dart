import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  Widget _buildContactItem(IconData icon, String text, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
      trailing: onTap != null ? const Icon(Icons.open_in_new) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto y nombre
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/my_photo.jpg'),
                      onBackgroundImageError: (exception, stackTrace) {
                        // En caso de error al cargar la imagen
                      },
                      child: const Icon(Icons.person, size: 60), // Fallback
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Eddy Martinez', 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Matrícula: 2023-0944', 
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Desarrollador Flutter',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Información de contacto
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Información de Contacto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildContactItem(
                    Icons.email,
                    '20230944@itla.edu.do', 
                    () => _launchUrl('mailto:tu.email@universidad.edu'),
                  ),
                  _buildContactItem(
                    Icons.phone,
                    '+1 (809) XXX-XXXX', // Reemplaza con tu teléfono
                    () => _launchUrl('tel:+1809XXXXXXX'),
                  ),
                  _buildContactItem(
                    Icons.download,
                    'Descargar APK',
                    () => _launchUrl('https://drive.google.com/drive/folders/1bb9ftgf2xZeEijTzp9cBCOcwpoOHzouQ?usp=drive_link'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Información de la aplicación
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sobre la Aplicación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Couteau es una aplicación de herramientas múltiples desarrollada en Flutter que incluye diversas funcionalidades útiles como predicción de género y edad, información de universidades, clima, Pokémon y noticias.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _buildTechStackItem('Flutter', 'Framework principal'),
                    _buildTechStackItem('Dart', 'Lenguaje de programación'),
                    _buildTechStackItem('APIs REST', 'Integración con servicios externos'),
                    _buildTechStackItem('Material Design', 'Diseño de interfaz'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // QR Code (opcional)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Descargar Aplicación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.qr_code, size: 100, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'QR Code para descargar APK',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Escanea este código para descargar la aplicación',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
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

  Widget _buildTechStackItem(String technology, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.code, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technology,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}