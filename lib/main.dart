import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
          create: (_) => SettingsProvider(), 
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            weatherService: WeatherService(apiKey: apiKey),
            locationService: LocationService(),
            storageService: StorageService(),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: settings.themeMode, 
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
