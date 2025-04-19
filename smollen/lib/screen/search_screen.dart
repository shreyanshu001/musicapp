// screens/search_screen.dart
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                hintText: 'e.g. London, New York',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          provider.getAutocompleteSuggestions('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                provider.getAutocompleteSuggestions(value);
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  provider.fetchWeatherData(value);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.autocompleteSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = provider.autocompleteSuggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(suggestion),
                    onTap: () {
                      provider.fetchWeatherData(suggestion);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            if (provider.searchHistory.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Searches',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: provider.searchHistory.length,
                  itemBuilder: (context, index) {
                    final city = provider.searchHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(city),
                      onTap: () {
                        provider.fetchWeatherData(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
