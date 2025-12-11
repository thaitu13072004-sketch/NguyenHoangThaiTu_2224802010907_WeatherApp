
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier 
{
  final WeatherService weatherService;
  final LocationService locationService;
  final StorageService storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  WeatherProvider({
    required this.weatherService,
    required this.locationService,
    required this.storageService,
  });

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeatherByCity(String cityName) async 
  {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather = await weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await weatherService.getForecast(cityName);
      await storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) 
    {
      _state = WeatherState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async 
  {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();
      _currentWeather = await weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      final cityName =
          await locationService.getCityName(position.latitude, position.longitude);
      _forecast = await weatherService.getForecast(cityName);
      await storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      await loadCachedWeather();
    }

    notifyListeners();
  }

  Future<void> loadCachedWeather() async 
  {
    final cached = await storageService.getCachedWeather();
    if (cached != null) {
      _currentWeather = cached;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}
