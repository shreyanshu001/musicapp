import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.weatherapi.com/v1';

  WeatherService({required this.apiKey});

  Future<WeatherModel> getCurrentWeather(String city) async {
    final url = '$baseUrl/current.json?key=$apiKey&q=$city&aqi=no';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response body: ${response.body}');
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }

  Future<ForecastModel> getForecast(String city) async {
    final url = '$baseUrl/forecast.json?key=$apiKey&q=$city&aqi=no&alerts=no';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response body: ${response.body}');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ForecastModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to forecast service: $e');
    }
  }

  // Simple city name autocomplete (mock implementation)
  List<String> getAutocompleteSuggestions(String query) {
    final cities = [
      'London',
      'New York',
      'Tokyo',
      'Paris',
      'Berlin',
      'Moscow',
      'Sydney',
      'Mumbai',
      'Delhi',
      'New Delhi',
      'Shanghai',
      'São Paulo'
    ];

    if (query.isEmpty) {
      return [];
    }

    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
