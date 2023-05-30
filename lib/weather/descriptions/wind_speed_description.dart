import 'package:flutter/material.dart';

class WindSpeedDescription extends StatelessWidget {
  final double speed;
  final List<String> shortDescriptions = [
    'Calm (< 1 km/h)',
    'Light air (1 km/h - 6 km/h)',
    'Light breeze (6 km/h - 12 km/h)',
    'Gentle breeze (12 km/h - 20 km/h)',
    'Moderate breeze (20 km/h - 29 km/h)',
    'Fresh breeze (29 km/h - 38 km/h)',
    'Strong breeze (38 km/h - 50 km/h)',
    'Near gale (50 km/h - 62 km/h)',
    'Gale (62 km/h - 75 km/h)',
    'Strong gale (75 km/h - 89 km/h)',
    'Storm (89 km/h - 103 km/h)',
    'Violent storm (103 km/h - 118 km/h)',
    'Hurricane (> 118 km/h)',
  ];
  WindSpeedDescription({required this.speed, Key? key}) : super(key: key);

  int getDescription(double speed) {
    if (speed < 1) {
      return 0;
    } else if (speed < 6) {
      return 1;
    } else if (speed < 12) {
      return 2;
    } else if (speed < 20) {
      return 3;
    } else if (speed < 29) {
      return 4;
    } else if (speed < 38) {
      return 5;
    } else if (speed < 50) {
      return 6;
    } else if (speed < 62) {
      return 7;
    } else if (speed < 75) {
      return 8;
    } else if (speed < 89) {
      return 9;
    } else if (speed < 103) {
      return 10;
    } else if (speed < 118) {
      return 11;
    } else {
      return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          shortDescriptions[getDescription(speed)],
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Dismiss'),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
