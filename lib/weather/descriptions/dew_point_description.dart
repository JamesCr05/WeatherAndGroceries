import 'package:flutter/material.dart';

class DewPointDescription extends StatelessWidget {
  final double temperature;
  final List<String> shortDescriptions = [
    'Dry (< 10 °C)',
    'Comfortable (10 °C - 15 °C)',
    'Sticky (15 °C - 18 °C)',
    'Uncomfortable (18 °C - 21 °C)',
    'Oppressive (21 °C - 24 °C)',
    'Miserable (24 °C - 27 °C)',
    'Dangerous (> 27 °C)',
  ];

  DewPointDescription({required this.temperature, Key? key}) : super(key: key);

  int getDescription(double temperature) {
    if (temperature < 10) {
      return 0;
    } else if (temperature < 15) {
      return 1;
    } else if (temperature < 18) {
      return 2;
    } else if (temperature < 21) {
      return 3;
    } else if (temperature < 24) {
      return 4;
    } else if (temperature < 27) {
      return 5;
    } else {
      return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          shortDescriptions[getDescription(temperature)],
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      content: const Text(
          'Higher dew points limit the body\'s ability to evaporate sweat and are therefore less comfortable. Unlike relative humidity, the dew point accounts for the air\'s ability to hold more moisture as the temperature increases, so the dew point is typically a better gauge for outdoor comfort.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Dismiss'),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
