class Constants {
  static const String openWeatherMapApiKey = "";
  static const String openWeatherMapBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
