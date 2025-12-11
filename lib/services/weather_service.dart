
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {'q': cityName},
      apiKey,
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat, double lon) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {'lat': '$lat', 'lon': '$lon'},
      apiKey,
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<ForecastModel>> getForecast(String cityName) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {'q': cityName},
      apiKey,
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      return list.map((item) => ForecastModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
