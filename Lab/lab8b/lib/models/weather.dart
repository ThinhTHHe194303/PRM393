class Weather {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final int maxRainChance;

  Weather({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.maxRainChance,
  });

  /// Builds a Weather object from the Open-Meteo forecast JSON.
  /// City and country come from the geocoding response.
  factory Weather.fromJson(
      Map<String, dynamic> json, String city, String country) {
    final current = json['current'] as Map<String, dynamic>;
    final rainList =
        (json['hourly']?['precipitation_probability'] as List?) ?? [];

    // Highest hourly rain probability of the day
    final maxRain = rainList.isEmpty
        ? 0
        : rainList
        .map((e) => (e as num?)?.toInt() ?? 0)
        .reduce((a, b) => a > b ? a : b);

    return Weather(
      city: city,
      country: country,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      maxRainChance: maxRain,
    );
  }

  /// Human-readable description from the WMO weather code.
  String get description {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 3) return 'Partly cloudy';
    if (weatherCode == 45 || weatherCode == 48) return 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Rain';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snow';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Rain showers';
    if (weatherCode >= 95) return 'Thunderstorm';
    return 'Unknown';
  }

  /// Emoji icon matching the weather code.
  String get icon {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode == 45 || weatherCode == 48) return '🌫️';
    if (weatherCode >= 51 && weatherCode <= 67) return '🌧️';
    if (weatherCode >= 71 && weatherCode <= 77) return '❄️';
    if (weatherCode >= 80 && weatherCode <= 82) return '🌦️';
    if (weatherCode >= 95) return '⛈️';
    return '🌡️';
  }

  // ---- Purpose-driven recommendations ----

  /// Umbrella advice based on rain chance and current precipitation.
  String get umbrellaAdvice => (maxRainChance >= 50 || precipitation > 0)
      ? '☂️ Take an umbrella (rain chance $maxRainChance%)'
      : '😎 No umbrella needed (rain chance $maxRainChance%)';

  /// Outdoor activity advice based on temperature and weather conditions.
  String get activityAdvice {
    if (weatherCode >= 95) return '⚠️ Thunderstorm expected, stay indoors';
    if (temperature >= 35) return '🔥 Too hot for outdoor sports';
    if (temperature <= 15) return '🧥 Quite cold, wear a warm jacket';
    if (maxRainChance >= 50) return '🏠 Likely rain, choose indoor activities';
    return '🚶 Nice weather for a walk';
  }
}