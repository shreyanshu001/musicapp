// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollen/screen/home_screen.dart';
import 'providers/weather_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String apiKey = 'fe809bbe9880420a81c192227250704';
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(apiKey: apiKey),
      child: MaterialApp(
        title: 'Weather Dashboard',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
