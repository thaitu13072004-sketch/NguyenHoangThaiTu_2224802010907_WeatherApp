import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Đơn vị nhiệt độ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          RadioListTile<TemperatureUnit>(
            title: const Text('°C – Celsius'),
            value: TemperatureUnit.celsius,
            groupValue: settings.tempUnit,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setTempUnit(value);
              }
            },
          ),
          RadioListTile<TemperatureUnit>(
            title: const Text('°F – Fahrenheit'),
            value: TemperatureUnit.fahrenheit,
            groupValue: settings.tempUnit,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setTempUnit(value);
              }
            },
          ),

          const Divider(),

          const ListTile(
            title: Text(
              'Định dạng thời gian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<TimeFormat>(
            title: const Text('24 giờ (13:00)'),
            value: TimeFormat.h24,
            groupValue: settings.timeFormat,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setTimeFormat(value);
              }
            },
          ),
          RadioListTile<TimeFormat>(
            title: const Text('12 giờ (1:00 PM)'),
            value: TimeFormat.h12,
            groupValue: settings.timeFormat,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setTimeFormat(value);
              }
            },
          ),

          const Divider(),

          const ListTile(
            title: Text(
              'Giao diện (Theme)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Theo hệ thống'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Sáng'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Tối'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsProvider>().setThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
