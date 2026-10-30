import 'package:flutter/material.dart';
import 'pages/inicio.dart';

void main() {
  runApp(const DudaReceitas());
}

class DudaReceitas extends StatelessWidget {
  const DudaReceitas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DudaReceitas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF496747),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF7F0),
        useMaterial3: true,
      ),
      home: const Inicio(),
    );
  }
}