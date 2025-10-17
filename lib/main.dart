import 'package:flutter/material.dart';
import 'screens/Telasensor.dart'; 

void main() {
  // O RegadorApp pode ser const se a classe for bem definida.
  runApp(const RegadorApp());
}

class RegadorApp extends StatelessWidget {
  const RegadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Regador Automático',
      theme: ThemeData(
        // Constantes para cores e temas são ideais.
        scaffoldBackgroundColor: const Color(0xFF015A84),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF015A84),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      // CORREÇÃO: Removido o 'const' daqui para que a tela possa ser inicializada dinamicamente.
      home: const Telasensor(), // aqui você define a tela de sensor como inicial
      debugShowCheckedModeBanner: false,
    );
  }
}
