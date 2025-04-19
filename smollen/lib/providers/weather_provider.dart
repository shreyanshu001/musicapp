// providers/weather_provider.dart
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_services.dart';
import '../services/storage_services.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService;
  final StorageService _storageService = StorageService();

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _currentWeather;
  ForecastModel? _forecast;
  String? _errorMessage;
  List<String> _searchHistory = [];
  String _currentCity = 'New Delhi'; // Default city
  List<String> _autocompleteSuggestions = [];

  WeatherProvider({required String apiKey})
      : _weatherService = WeatherService(apiKey: apiKey) {
    _initializeData();
  }

  WeatherStatus get status => _status;
  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  String? get errorMessage => _errorMessage;
  List<String> get searchHistory => _searchHistory;
  String get currentCity => _currentCity;
  List<String> get autocompleteSuggestions => _autocompleteSuggestions;

  Future<void> _initializeData() async {
    // Load search history
    _searchHistory = await _storageService.getSearchHistory();

    // Load last weather data if available
    final lastWeather = await _storageService.getLastWeather();

    if (lastWeather != null) {
      _currentWeather = lastWeather;
      _currentCity = lastWeather.cityName;
      _status = WeatherStatus.loaded;
      notifyListeners();
    }

    // Even if we have cached data, refresh it
    if (_searchHistory.isNotEmpty) {
      await fetchWeatherData(_searchHistory.first);
    } else {
      // If no search history, use the default city
      await fetchWeatherData(_currentCity);
    }
  }

  Future<void> fetchWeatherData(String city) async {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch current weather
      final weather = await _weatherService.getCurrentWeather(city);
      _currentWeather = weather;
      _currentCity = city;

      // Fetch forecast
      final forecast = await _weatherService.getForecast(city);
      _forecast = forecast;

      // Save to storage
      await _storageService.saveLastWeather(weather);
      await _storageService.addToSearchHistory(city);

      // Update search history
      _searchHistory = await _storageService.getSearchHistory();

      _status = WeatherStatus.loaded;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void getAutocompleteSuggestions(String query) {
    _autocompleteSuggestions =
        _weatherService.getAutocompleteSuggestions(query);
    notifyListeners();
  }
}
