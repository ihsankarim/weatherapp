import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/data/repositories/weather_repository.dart';
import 'package:weatherapp/models/weather.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherViewmodel with ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherViewmodel({required this.weatherRepository});

  Weather? _weather;
  WeatherState _state = WeatherState.initial;
  String? _errorMessage;

  Weather? get weather => _weather;
  WeatherState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) {
      _errorMessage = 'Nama kota tidak boleh kosong.';
      _state = WeatherState.error;
      notifyListeners();
      return;
    }
    _state = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await weatherRepository.getWeather(cityName);
      _state = WeatherState.error;
      _weather = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = WeatherState.error;
      _weather = null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCurrentLocationWeather() async {
    _state = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Position position = await _determinePosition();
      _weather = await weatherRepository.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
      _state = WeatherState.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = WeatherState.error;
      _weather = null;
    } finally {
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi dinonaktifkan. ');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditalok');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Izin lokasi secara permanen, kami tidak dapat meminta izin. ',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }
}
