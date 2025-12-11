// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  // Vì dùng async nên phải ensureInitialized trước
  WidgetsFlutterBinding.ensureInitialized();

  // Load biến môi trường từ file .env trong root project
  await dotenv.load(fileName: ".env");

  // Lấy API key từ .env
  final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  runApp(MyApp(apiKey: apiKey));
}

class MyApp extends StatelessWidget {
  final String apiKey;

  const MyApp({super.key, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherService: WeatherService(apiKey: apiKey),
            locationService: LocationService(),
            storageService: StorageService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
