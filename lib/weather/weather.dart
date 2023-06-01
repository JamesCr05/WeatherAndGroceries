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
  late DateTime intervalTime;
  late double futureTemp1;
  late double futureTemp2;
  late double futureTemp3;
  late String futureCond1;
  late String futureCond2;
  late String futureCond3;
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
    var forecastData = await weatherModel.getForecast(latitude, longitude);
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
      condition = weatherData['weather'][0]['description'];
      humidity = weatherData['main']['humidity'];
      country = weatherData['sys']['country'];
      city = weatherData['name'];
      temperature = weatherData['main']['temp'].toDouble();
      feelsLike = weatherData['main']['feels_like'].toDouble();
      windSpeed = weatherData['wind']['speed'].toDouble();
      intervalTime = DateTime.fromMillisecondsSinceEpoch(
              forecastData['list'][0]['dt'] * 1000)
          .toUtc()
          .add(Duration(seconds: timeZone));
      futureTemp1 = forecastData['list'][0]['main']['temp'].toDouble();
      futureTemp2 = forecastData['list'][1]['main']['temp'].toDouble();
      futureTemp3 = forecastData['list'][2]['main']['temp'].toDouble();
      futureCond1 = forecastData['list'][0]['weather'][0]['description'];
      futureCond2 = forecastData['list'][1]['weather'][0]['description'];
      futureCond3 = forecastData['list'][2]['weather'][0]['description'];
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
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
                    ),
                  if (!automaticLocation)
                    const SizedBox(
                      height: 20,
                    ), // Set longitude and latitude
                  Text(
                    '${DateFormat('d MMMM yyyy, HH:mm').format(time)} GMT$timeZoneString',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ), // Date and time
                  Text(
                    '$city, $country',
                    textAlign: TextAlign.center,
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
                    '${condition.substring(0, 1).toUpperCase()}${condition.substring(1)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ), // Condition
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 7 / 9,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(127, 127, 127, 1),
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
                                                    (243.12 + temperature)))) /
                                        (17.62 -
                                            (log(humidity / 100) +
                                                ((17.62 * temperature) /
                                                    (243.12 + temperature))))),
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
                                TemperatureDescription(temperature: feelsLike),
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
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                TemperatureDescription(
                                    temperature: futureTemp1),
                          ),
                          child: Text(
                            '${DateFormat('HH:mm').format(intervalTime)}  ${futureTemp1.round()} °C, $futureCond1',
                            textAlign: TextAlign.center,
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
                                    temperature: futureTemp2),
                          ),
                          child: Text(
                            '${DateFormat('HH:mm').format(intervalTime.add(const Duration(hours: 3)))}  ${futureTemp2.round()} °C, $futureCond2',
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
                                    temperature: futureTemp3),
                          ),
                          child: Text(
                            '${DateFormat('HH:mm').format(intervalTime.add(const Duration(hours: 6)))}  ${futureTemp3.round()} °C, $futureCond3',
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
                          onPressed: null,
                          child: Text(
                            'Sunrise: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunrise * 1000))}',
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
                          onPressed: null,
                          child: Text(
                            'Sunset: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunset * 1000))}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), // Information panel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Use device time zone'),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Switch(
                          value: deviceTimeZone,
                          onChanged: (bool value) {
                            setState(() {
                              deviceTimeZone = value;
                              getWeatherData();
                            });
                          },
                        ),
                      ),
                    ],
                  ), // Time zone setting
                ],
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
