import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _service = WeatherService();
  final _controller = TextEditingController(text: 'Hanoi');
  late Future<Weather> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Starts a new request for the city currently in the text field.
  void _load() {
    _future = _service.fetchWeatherForCity(_controller.text.trim());
  }

  /// Triggers a rebuild so FutureBuilder listens to the new future.
  /// Also used by the Retry button.
  void _search() => setState(_load);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Companion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search form
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter a city name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Result area: loading / error / empty / data
            Expanded(
              child: FutureBuilder<Weather>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _buildError(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No data available'));
                  }
                  return _buildWeather(snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Error state with a Retry button.
  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            message.replaceFirst('Exception: ', ''),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _search,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Success state: main card, details card, recommendation card.
  Widget _buildWeather(Weather w) {
    return ListView(
      children: [
        // Main card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '${w.city}, ${w.country}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(w.icon, style: const TextStyle(fontSize: 64)),
                Text(
                  '${w.temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(w.description),
              ],
            ),
          ),
        ),

        // Details card
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text('Feels like'),
                trailing: Text('${w.feelsLike.toStringAsFixed(1)}°C'),
              ),
              ListTile(
                leading: const Icon(Icons.air),
                title: const Text('Wind speed'),
                trailing: Text('${w.windSpeed} km/h'),
              ),
              ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text('Humidity'),
                trailing: Text('${w.humidity}%'),
              ),
            ],
          ),
        ),

        // Recommendation card (purpose-driven element)
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.umbrellaAdvice, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(w.activityAdvice, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}