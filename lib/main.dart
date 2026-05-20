import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const AdvancedCarMatchApp());
}

class AdvancedCarMatchApp extends StatelessWidget {
  const AdvancedCarMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Speed Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B071E),
      ),
      home: const GameScreen(),
    );
  }
}