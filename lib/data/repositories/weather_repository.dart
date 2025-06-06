import 'package:weatherapp/data/api/weather_api_client.dart';
import 'package:weatherapp/models/weather.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({required this.weatherApiClient});

  Future<Weather> getWeather(String cityName) async {
    return await weatherApiClient.fetchWeather(cityName);
  }

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    return await weatherApiClient.fetchWeatherByCoordiates(lat, lon);
  }
}