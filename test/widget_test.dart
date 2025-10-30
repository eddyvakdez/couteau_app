import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:couteau_app/main.dart';
import 'package:couteau_app/views/home_screen.dart';

void main() {
  testWidgets('La aplicación se inicia correctamente', (WidgetTester tester) async {
    // Construye nuestra app y dispara un frame
    await tester.pumpWidget(const MyApp());

    // Verifica que nuestro HomeScreen esté presente
    expect(find.byType(HomeScreen), findsOneWidget);
    
    // Verifica que el título de la app esté presente
    expect(find.text('Couteau - Caja de Herramientas'), findsOneWidget);
  });

  testWidgets('El HomeScreen muestra todas las herramientas', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verifica que todas las herramientas estén presentes
    expect(find.text('Predicción de Género'), findsOneWidget);
    expect(find.text('Predicción de Edad'), findsOneWidget);
    expect(find.text('Universidades'), findsOneWidget);
    expect(find.text('Clima RD'), findsOneWidget);
    expect(find.text('Pokémon'), findsOneWidget);
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Acerca de'), findsOneWidget);
  });

  testWidgets('Los iconos de las herramientas están presentes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verifica que los iconos estén presentes
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.cake), findsOneWidget);
    expect(find.byIcon(Icons.school), findsOneWidget);
    expect(find.byIcon(Icons.cloud), findsOneWidget);
    expect(find.byIcon(Icons.catching_pokemon), findsOneWidget);
    expect(find.byIcon(Icons.article), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);
  });
}