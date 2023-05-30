import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'descriptions/temperature_description.dart';
import 'descriptions/dew_point_description.dart';
import 'descriptions/wind_speed_description.dart';
import 'weather_service.dart';
import 'package:metric/reusable_drawer.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  bool deviceTimeZone = true;
  late int timeZone;
  late String timeZoneString;
  late DateTime time;
  bool automaticLocation = false;
  double latitude = 39.069;
  double longitude = -76.548;
  late double temperature;
  late double feelsLike;
  late double high;
  late double low;
  late double windSpeed;
  late String condition;
  late int humidity;
  late String country;
  late String city;
  late int sunrise;
  late int sunset;
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  getWeatherData() async {
    var weatherData =
        await weatherModel.getLocationWeather(latitude, longitude);
    setState(() {
      if (deviceTimeZone) {
        timeZone = DateTime.now().timeZoneOffset.inSeconds;
        sunrise = weatherData['sys']['sunrise'];
        sunset = weatherData['sys']['sunset'];
      } else {
        timeZone = weatherData['timezone'];
        sunrise = weatherData['sys']['sunrise'] -
            DateTime.now().timeZoneOffset.inSeconds +
            weatherData['timezone'];
        sunset = weatherData['sys']['sunset'] -
            DateTime.now().timeZoneOffset.inSeconds +
            weatherData['timezone'];
      }
      if (timeZone > 0) {
        timeZoneString = '+${(timeZone / 3600).toString()}';
      } else if (timeZone < 0) {
        timeZoneString = (timeZone / 3600).toString();
      } else {
        timeZoneString = '';
      }
      if (timeZone % 3600 == 0 && timeZone != 0) {
        timeZoneString = timeZoneString.substring(0, timeZoneString.length - 2);
      }
      time = DateTime.now().toUtc().add(Duration(seconds: timeZone));
      condition = weatherData['weather'][0]['main'];
      humidity = weatherData['main']['humidity'];
      country = weatherData['sys']['country'];
      city = weatherData['name'];
      temperature = weatherData['main']['temp'].toDouble();
      feelsLike = weatherData['main']['feels_like'].toDouble();
      high = weatherData['main']['temp_max'].toDouble();
      low = weatherData['main']['temp_min'].toDouble();
      windSpeed = weatherData['wind']['speed'].toDouble();
    });
  }

  getLocationData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Color getColor(double temperature) {
    if (temperature < -15) {
      return Colors.indigo;
    } else if (temperature < 0) {
      return Colors.lightBlue;
    } else if (temperature < 10) {
      return Colors.tealAccent;
    } else if (temperature < 17) {
      return Colors.greenAccent;
    } else if (temperature < 25) {
      return Colors.green;
    } else if (temperature < 30) {
      return Colors.amber;
    } else if (temperature < 35) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        drawer: const ReusableDrawer(),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  getWeatherData();
                });
              },
            ),
            if (automaticLocation)
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () {
                  setState(() {
                    automaticLocation = !automaticLocation;
                    getWeatherData();
                  });
                },
              ),
            if (!automaticLocation)
              IconButton(
                icon: const Icon(Icons.location_off),
                onPressed: () {
                  setState(() {
                    automaticLocation = !automaticLocation;
                    getLocationData();
                  });
                },
              ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!automaticLocation)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Latitude',
                                suffixText: '°',
                              ),
                              initialValue: latitude.toString(),
                              onFieldSubmitted: (String? value) {
                                setState(() {
                                  latitude = double.parse(value!);
                                  getWeatherData();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Longitude',
                                suffixText: '°',
                              ),
                              initialValue: longitude.toString(),
                              onFieldSubmitted: (String? value) {
                                setState(() {
                                  longitude = double.parse(value!);
                                  getWeatherData();
                                });
                              },
                            ),
                          ),
                        ],
                      ), // Set longitude and latitude
                    Text(
                      '${DateFormat('d MMMM yyyy, HH:mm').format(time)} GMT$timeZoneString',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ), // Date and time
                    Text(
                      '$city, $country',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ), // City and country
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            TemperatureDescription(temperature: temperature),
                      ),
                      child: Text(
                        '${temperature.round()} °C',
                        style: TextStyle(
                          fontSize: 120,
                          color: getColor(temperature),
                        ),
                      ),
                    ), // Temperature
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ), // Condition
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(100, 100, 100, 1),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Column(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  DewPointDescription(
                                      temperature: (243.12 *
                                              (log(humidity / 100) +
                                                  ((17.62 * temperature) /
                                                      (243.12 +
                                                          temperature)))) /
                                          (17.62 -
                                              (log(humidity / 100) +
                                                  ((17.62 * temperature) /
                                                      (243.12 +
                                                          temperature))))),
                            ),
                            child: Text(
                              'Dew point: ${((243.12 * (log(humidity / 100) + ((17.62 * temperature) / (243.12 + temperature)))) / (17.62 - (log(humidity / 100) + ((17.62 * temperature) / (243.12 + temperature))))).round()} °C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  TemperatureDescription(
                                      temperature: feelsLike),
                            ),
                            child: Text(
                              'Feels like: ${feelsLike.round()} °C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  TemperatureDescription(temperature: high),
                            ),
                            child: Text(
                              'High: ${high.round()} °C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  TemperatureDescription(temperature: low),
                            ),
                            child: Text(
                              'Low: ${low.round()} °C',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  WindSpeedDescription(speed: windSpeed * 3.6),
                            ),
                            child: Text(
                              'Wind speed: ${(windSpeed * 3.6).round()} km/h',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Sunrise: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000))}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Sunset: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunset * 1000))}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ), // Information panel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Use device time zone'),
                        Switch(
                          value: deviceTimeZone,
                          onChanged: (bool value) {
                            setState(() {
                              deviceTimeZone = value;
                              //print('Value $value');
                              //print('Device time zone $deviceTimeZone');
                              getWeatherData();
                            });
                          },
                        ),
                      ],
                    ), // Time zone setting
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return SafeArea(
        child: Scaffold(
          drawer: const ReusableDrawer(),
          appBar: AppBar(),
          body: const Center(
            child: Text(
              'Please wait for the weather data to be fetched.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
