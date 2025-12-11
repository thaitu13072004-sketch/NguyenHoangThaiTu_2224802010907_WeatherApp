import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import 'search_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshWeather(),
        child: Builder(
          builder: (context) {
            // Trạng thái loading
            if (provider.state == WeatherState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (provider.state == WeatherState.error &&
                provider.currentWeather == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.errorMessage),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.fetchWeatherByLocation(),
                      child: const Text("Thử lại"),
                    ),
                  ],
                ),
              );
            }

            // Không có dữ liệu
            if (provider.currentWeather == null) {
              return const Center(
                child: Text("Không có dữ liệu thời tiết"),
              );
            }

            // UI chính
            return ListView(
              children: [
                CurrentWeatherCard(weather: provider.currentWeather!),
                const SizedBox(height: 12),
                HourlyForecastList(forecasts: provider.forecast),
                const SizedBox(height: 12),
                DailyForecastSection(forecasts: provider.forecast),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
