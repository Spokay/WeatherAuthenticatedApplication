import 'dart:convert';

import 'package:http/http.dart';
import 'package:zoubida/config/weather_api_config.dart';

class WeatherService{
  late String weatherUrl;
  late String apiHost;
  late int apiPort;
  late String apiUrl;
  late String apiKey;

  WeatherService({String? authUrl, String ?apiHost, int ?apiPort, String ?apiUrl, String? apiKey}){
    weatherUrl = authUrl ?? WeatherApiConfig.weatherUrl;
    this.apiHost = apiHost ?? WeatherApiConfig.apiHost;
    this.apiPort = apiPort ?? WeatherApiConfig.apiPort;
    this.apiUrl = apiUrl ?? WeatherApiConfig.apiUrl;
    this.apiKey = apiKey ?? WeatherApiConfig.apiKey;
  }
  Future<Map<String, dynamic>> getWeatherForAWeekByCityName(String city) async {
    Response response = await get(
        Uri.parse("https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no"),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getWeatherForAWeekByCoordinates(double lat, double long) async {
    Response response = await get(
      Uri.parse("https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$long&days=7&aqi=no&alerts=no"),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    return data;
  }
}