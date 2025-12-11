import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _search() async {
    final city = _controller.text.trim();

    if (city.isEmpty) {
      setState(() {
        _errorText = "Vui lòng nhập tên thành phố";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final weatherProvider = context.read<WeatherProvider>();

    try {
      await weatherProvider.fetchWeatherByCity(city);
      if (!mounted) return;
      Navigator.pop(context); // quay lại HomeScreen, dữ liệu đã được cập nhật
    } catch (e) {
      setState(() {
        _errorText = "Không tìm thấy thành phố hoặc lỗi mạng";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm thành phố"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: "Nhập tên thành phố (ví dụ: London, Ho Chi Minh)",
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _search,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(_isLoading ? "Đang tìm..." : "Tìm kiếm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
