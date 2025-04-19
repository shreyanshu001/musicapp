// screens/home_screen.dart
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
// import '../widgets/weather_details_widget.dart';
import '../widgets/forecast_widget.dart';
import '../widgets/loading_widget.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.currentWeather;

    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: RefreshIndicator(
        onRefresh: () => provider.fetchWeatherData(provider.currentCity),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: Colors.blue[600],
              flexibleSpace: FlexibleSpaceBar(
                background: weather != null
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue[700]!, Colors.blue[500]!],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0), // adjust top spacing as needed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // const SizedBox(height: 2),
                              Text(
                                '${weather.temperature.round()}°',
                                style: const TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                weather.condition,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'H:${weather.temperature.round()}° L:17°',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(color: Colors.blue[600]),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () =>
                      provider.fetchWeatherData(provider.currentCity),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: provider.status == WeatherStatus.loading
                  ? const LoadingWidget()
                  : provider.status == WeatherStatus.error
                      ? _buildErrorWidget(context, provider.errorMessage)
                      : provider.status == WeatherStatus.loaded
                          ? _buildWeatherContent(context, provider)
                          : const Center(
                              child: Text('Search for a city to get started')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;

    return Container(
      color: Colors.blue[600],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.blue[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(
                            context,
                            'FEELS LIKE',
                            '${weather.feelsLike.round()}°',
                            'It feels warmer than actual temperature.'),
                        _buildWeatherDetail(context, 'UV INDEX', '0',
                            'Low for the rest of the day.'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(
                            context,
                            'WIND',
                            '${weather.windSpeed.round()} km/h',
                            'Direction: ${weather.windDirection}'),
                        const SizedBox(width: 16),
                        _buildWindDirectionIndicator(weather.windDirection),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(context, 'SUNSET',
                            DateFormat('HH:mm').format(weather.sunset), ''),
                        _buildWeatherDetail(
                            context, 'PRECIPITATION', '0 mm', 'Today'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: Colors.blue[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(
                            context,
                            'VISIBILITY',
                            '${weather.visibility.round()} km',
                            'Perfectly clear view.'),
                        _buildWeatherDetail(
                            context,
                            'HUMIDITY',
                            '${weather.humidity}%',
                            'The dew point is 2° right now.'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Moon phase section from screenshots
                    _buildMoonPhaseSection(context),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherDetail(context, 'AVERAGES', '0°',
                            'from average daily high'),
                        _buildWeatherDetail(context, 'PRESSURE',
                            '${weather.pressure.round()} hPa', ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 10-Day forecast section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: ForecastWidget(),
          ),
          // Air quality section from screenshots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: Colors.blue[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AIR QUALITY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '117',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Moderately Polluted',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(
                      value: 0.55,
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Air quality index is 117, which is similar to yesterday at about this time.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(
      BuildContext context, String title, String value, String description) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (description.isNotEmpty)
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWindDirectionIndicator(String direction) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          direction,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMoonPhaseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WAXING CRESCENT',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Illumination',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const Text(
              '13%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Moonset',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const Text(
              '22:11',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Next Full Moon',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const Text(
              '12 days',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Image.asset(
            'assets/moon_phase.png', // You would need to add this image
            width: 100,
            height: 100,
            // Or use a simple circle with gradient if image not available
            errorBuilder: (context, error, stackTrace) => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, Colors.blue[600]!],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, String? errorMessage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.red[400],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'Error loading weather data',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Unknown error',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Provider.of<WeatherProvider>(context, listen: false)
                        .fetchWeatherData(
                            Provider.of<WeatherProvider>(context, listen: false)
                                .currentCity),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
