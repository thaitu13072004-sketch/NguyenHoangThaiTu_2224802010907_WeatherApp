
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_model.dart';

class StorageService 
{
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';

  Future<void> saveWeatherData(WeatherModel weather) async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async 
  {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_weatherKey);
    if (data == null) return null;
    return WeatherModel.fromJson(json.decode(data));
  }

  Future<bool> isCacheValid() async 
  {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;
    final diff = DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return diff < 30 * 60 * 1000; // < 30 phút
  }

  Future<void> saveFavoriteCities(List<String> cities) async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async 
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }
}
