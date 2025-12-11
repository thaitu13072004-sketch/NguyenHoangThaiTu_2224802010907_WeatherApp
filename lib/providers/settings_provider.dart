import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TemperatureUnit { celsius, fahrenheit }
enum TimeFormat { h24, h12 }

class SettingsProvider extends ChangeNotifier {
  static const _keyTempUnit = 'temp_unit';
  static const _keyTimeFormat = 'time_format';
  static const _keyThemeMode = 'theme_mode';

  TemperatureUnit _tempUnit = TemperatureUnit.celsius;
  TimeFormat _timeFormat = TimeFormat.h24;
  ThemeMode _themeMode = ThemeMode.system;

  SettingsProvider() {
    _loadSettings();
  }

  TemperatureUnit get tempUnit => _tempUnit;
  TimeFormat get timeFormat => _timeFormat;
  ThemeMode get themeMode => _themeMode;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final tu = prefs.getString(_keyTempUnit);
    if (tu == 'f') _tempUnit = TemperatureUnit.fahrenheit;

    final tf = prefs.getString(_keyTimeFormat);
    if (tf == '12') _timeFormat = TimeFormat.h12;

    final tm = prefs.getString(_keyThemeMode);
    if (tm == 'light') _themeMode = ThemeMode.light;
    if (tm == 'dark') _themeMode = ThemeMode.dark;

    notifyListeners();
  }

  Future<void> setTempUnit(TemperatureUnit unit) async {
    _tempUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyTempUnit, unit == TemperatureUnit.celsius ? 'c' : 'f');
    notifyListeners();
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    _timeFormat = format;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTimeFormat, format == TimeFormat.h24 ? '24' : '12');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await prefs.setString(_keyThemeMode, value);
    notifyListeners();
  }
  String formatTemperature(double tempCelsius) {
    if (_tempUnit == TemperatureUnit.celsius) {
      return '${tempCelsius.round()}°C';
    } else {
      final f = tempCelsius * 9 / 5 + 32;
      return '${f.round()}°F';
    }
  }
  String formatTime(DateTime dateTime) {
    if (_timeFormat == TimeFormat.h24) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('h:mm a').format(dateTime);
    }
  }
}
