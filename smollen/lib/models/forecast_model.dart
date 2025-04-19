class ForecastDay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final String icon;

  ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.icon,
  });
}

class ForecastModel {
  final List<ForecastDay> dailyForecasts;
  final DateTime timestamp;

  ForecastModel({
    required this.dailyForecasts,
    required this.timestamp,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List forecastDays = json['forecast']?['forecastday'] ?? [];

    final dailyForecasts = forecastDays.map((item) {
      return ForecastDay(
        date: DateTime.parse(item['date']),
        minTemp: item['day']['mintemp_c'].toDouble(),
        maxTemp: item['day']['maxtemp_c'].toDouble(),
        condition: item['day']['condition']['text'],
        icon: item['day']['condition']['icon'],
      );
    }).toList();

    return ForecastModel(
      dailyForecasts: dailyForecasts.cast<ForecastDay>(),
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyForecasts': dailyForecasts
          .map((forecast) => {
                'date': forecast.date.millisecondsSinceEpoch,
                'minTemp': forecast.minTemp,
                'maxTemp': forecast.maxTemp,
                'condition': forecast.condition,
                'icon': forecast.icon,
              })
          .toList(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
