class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final DateTime sunrise;
  final DateTime sunset;
  final double feelsLike;
  final double pressure;
  final double visibility;
  final String icon;
  final DateTime timestamp;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.sunrise,
    required this.sunset,
    required this.pressure,
    required this.visibility,
    required this.icon,
    required this.timestamp,
    required this.feelsLike,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final location = json['location'];

    return WeatherModel(
      cityName: location['name'] ?? 'Unknown',
      temperature: current['temp_c'].toDouble(),
      condition: current['condition']['text'] ?? 'Unknown',
      humidity: current['humidity'],
      windSpeed: current['wind_kph'].toDouble(),
      windDirection: current['wind_dir'] ?? 'N',
      sunrise: DateTime.now(), // Not available in this API response
      sunset: DateTime.now(), // Not available in this API response
      pressure: current['pressure_mb'].toDouble(),
      visibility: current['vis_km'].toDouble(),
      icon: 'https:${current['condition']['icon']}',
      timestamp: DateTime.now(),
      feelsLike: current['feelslike_c'].toDouble(),
    );
  }

  static String _getWindDirection(int degrees) {
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];
    return directions[(degrees ~/ 22.5) % 16];
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
      'pressure': pressure,
      'visibility': visibility,
      'icon': icon,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'feelsLike': feelsLike,
    };
  }
}
