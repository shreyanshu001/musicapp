import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecast = provider.forecast;

    if (forecast == null || forecast.dailyForecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.blue[400],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '10-DAY FORECAST',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: forecast.dailyForecasts.map((day) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            DateFormat('E').format(day.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.network(
                          'https://openweathermap.org/img/wn/${day.icon}.png',
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.cloud, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '${day.minTemp.round()}°',
                                style: const TextStyle(color: Colors.white60),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[300]!,
                                        Colors.orange
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Text(
                                '${day.maxTemp.round()}°',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (forecast.dailyForecasts.last != day)
                      const Divider(color: Colors.white24),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
