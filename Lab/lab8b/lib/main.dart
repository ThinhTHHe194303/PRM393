import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // Root widget of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}