import 'package:flutter/material.dart';

class WindMapCard extends StatelessWidget {
  final List<String> cities;

  const WindMapCard({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WIND MAP',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              children: cities
                  .map((city) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(city),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
