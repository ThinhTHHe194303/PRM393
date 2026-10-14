import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

/// Thrown when the geocoding API returns no match for the city name.
class CityNotFoundException implements Exception {
  final String city;
  CityNotFoundException(this.city);

  @override
  String toString() => 'City "$city" not found';
}

/// Handles all network calls to the Open-Meteo APIs.
class WeatherService {
  Future<Weather> fetchWeatherForCity(String city) async {
    // Step 1: city name -> coordinates (geocoding API)
    final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search',
        {'name': city, 'count': '1'});
    final geoRes = await http.get(geoUri).timeout(const Duration(seconds: 10));
    if (geoRes.statusCode != 200) {
      throw Exception('Geocoding error (${geoRes.statusCode})');
    }

    final results = jsonDecode(geoRes.body)['results'] as List?;
    if (results == null || results.isEmpty) throw CityNotFoundException(city);
    final place = results.first as Map<String, dynamic>;

    // Step 2: coordinates -> weather data (forecast API)
    final weatherUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${place['latitude']}',
      'longitude': '${place['longitude']}',
      'current':
      'temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,weather_code,wind_speed_10m',
      'hourly': 'precipitation_probability',
      'timezone': 'auto',
      'forecast_days': '1',
    });
    final res = await http.get(weatherUri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Weather request failed (${res.statusCode})');
    }

    // Step 3: parse JSON into a model
    return Weather.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
      place['name'] ?? city,
      place['country'] ?? '',
    );
  }
}