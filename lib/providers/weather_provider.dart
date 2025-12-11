import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService weatherService;
  final LocationService locationService;
  final StorageService storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  // 🔹 Lịch sử search
  List<String> _searchHistory = [];

  WeatherProvider({
    required this.weatherService,
    required this.locationService,
    required this.storageService,
  }) {
    _init();
  }

  Future<void> _init() async {
    await loadCachedWeather();
    await _loadSearchHistory();
  }

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  // getter đọc lịch sử (không cho sửa trực tiếp)
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  // 🔹 load history từ SharedPreferences
  Future<void> _loadSearchHistory() async {
    _searchHistory = await storageService.getSearchHistory();
    notifyListeners();
  }

  // 🔹 thêm 1 city vào history
  Future<void> _addToSearchHistory(String cityName) async {
    String normalized = cityName.trim();
    if (normalized.isEmpty) return;

    // Viết hoa chữ cái đầu (cho đẹp)
    normalized = normalized[0].toUpperCase() + normalized.substring(1);

    // Bỏ city cũ nếu trùng, rồi thêm lên đầu
    _searchHistory.removeWhere(
        (c) => c.toLowerCase() == normalized.toLowerCase());
    _searchHistory.insert(0, normalized);

    // Giữ tối đa 10 item
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await storageService.saveSearchHistory(_searchHistory);
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather = await weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await weatherService.getForecast(cityName);
      await storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';

      // 🔹 cập nhật history khi search thành công
      await _addToSearchHistory(cityName);
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();
      _currentWeather = await weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      // lấy city từ toạ độ rồi fetch forecast
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

  Future<void> loadCachedWeather() async {
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
