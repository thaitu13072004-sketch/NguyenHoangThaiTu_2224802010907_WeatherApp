import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF87CEEB),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${weather.cityName}, ${weather.country}",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl:
                "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
            height: 100,
          ),
          Text(
            settings.formatTemperature(weather.temperature),
            style: const TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "Feels like ${settings.formatTemperature(weather.feelsLike)}",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
