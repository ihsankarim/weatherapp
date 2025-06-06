import 'package:weatherapp/models/weather.dart';
import 'package:weatherapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApiClient {
  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse(
      '${Constants.openWeatherMapBaseUrl}?q=$cityName&appid=${Constants.openWeatherMapApiKey}&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Kota tidak ditemukan.');
    } else if (response.statusCode == 401) {
      throw Exception('Kunci API tidak valid atau tidak diberikan');
    } else {
      throw Exception('Gagal memuat data cuaca: ${response.statusCode}');
    }
  }

  Future<Weather> fetchWeatherByCoordiates(double lat, double lon) async {
    final url = Uri.parse(
      '${Constants.openWeatherMapBaseUrl}?lat=$lat&lon=$lon&appid=${Constants.openWeatherMapApiKey}&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat data cuaca berdasarkan koordinat.');
    }
  }
}
