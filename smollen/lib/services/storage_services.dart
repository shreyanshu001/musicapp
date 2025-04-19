// services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String SEARCH_HISTORY_KEY = 'search_history';
  static const String LAST_WEATHER_KEY = 'last_weather';
  static const String LAST_FORECAST_KEY = 'last_forecast';

  // Save search history
  Future<void> saveSearchHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SEARCH_HISTORY_KEY, history);
  }

  // Get search history
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(SEARCH_HISTORY_KEY) ?? [];
  }

  // Add a city to search history
  Future<void> addToSearchHistory(String city) async {
    final history = await getSearchHistory();

    // Add to beginning and remove duplicates
    if (history.contains(city)) {
      history.remove(city);
    }
    history.insert(0, city);

    // Limit to last 5 searches
    final limitedHistory = history.take(5).toList();
    await saveSearchHistory(limitedHistory);
  }

  // Save last weather data
  Future<void> saveLastWeather(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = json.encode(weather.toJson());
    await prefs.setString(LAST_WEATHER_KEY, weatherJson);
  }

  // Get last weather data
  Future<WeatherModel?> getLastWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(LAST_WEATHER_KEY);

    if (weatherJson == null) {
      return null;
    }

    try {
      final data = json.decode(weatherJson);
      return WeatherModel(
        cityName: data['cityName'],
        temperature: data['temperature'],
        condition: data['condition'],
        humidity: data['humidity'],
        windSpeed: data['windSpeed'],
        windDirection: data['windDirection'],
        sunrise: DateTime.fromMillisecondsSinceEpoch(data['sunrise']),
        sunset: DateTime.fromMillisecondsSinceEpoch(data['sunset']),
        pressure: data['pressure'],
        visibility: data['visibility'],
        icon: data['icon'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        feelsLike: data['feelsLike'],
      );
    } catch (e) {
      return null;
    }
  }

  // Save and retrieve forecast data methods would be similar
}
