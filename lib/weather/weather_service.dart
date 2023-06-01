import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkData {
  NetworkData(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
  }
}

class WeatherModel {
  Future<dynamic> getLocationWeather(double latitude, double longitude) async {
    NetworkData networkHelper = NetworkData(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid={INSERT_API_KEY}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getForecast(double latitude, double longitude) async {
    NetworkData networkHelper = NetworkData(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid={INSERT_API_KEY}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
