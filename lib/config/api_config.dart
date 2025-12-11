
class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  static String buildUrl(String endpoint, Map<String, dynamic> params, String apiKey) 
  {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    params['units'] = 'metric';
    return uri.replace(queryParameters: params).toString();
  }
}
