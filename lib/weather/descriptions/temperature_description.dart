import 'package:flutter/material.dart';

class TemperatureDescription extends StatelessWidget {
  final double temperature;
  final List<String> shortDescriptions = [
    'Frigid (< -15 °C)',
    'Freezing (-15 °C - 0 °C)',
    'Cold (0 °C - 10 °C)',
    'Cool (10 °C - 17 °C)',
    'Comfortable (17 °C - 25 °C)',
    'Warm (25 °C - 30 °C)',
    'Hot (30 °C - 35 °C)',
    'Sweltering (> 35 °C)',
  ];
  final List<String> longDescriptions = [
    'The temperature is far below the freezing point of water. A winter jacket and several additional layers of clothing should be worn. The risk of frostbite on exposed skin may be substantial.',
    'The temperature is cold enough to freeze water. A winter jacket is appropriate, and additional layers of clothing may be ideal.',
    'The temperature is above the freezing point of water but still feels cold to bare skin. One or two layers of moderately warm clothing are appropriate.',
    'The temperature is slightly cooler than most people find ideal. A light jacket may be appropriate.',
    'The temperature is roughly equal to that of a typical indoor space.',
    'The temperature is slightly warmer than most people find ideal. Loose-fitting clothing that does not cover the entire body is appropriate.',
    'The temperature is quite hot. Loose-fitting clothing that does not cover the entire body should be worn. This heat may accelerate physical exhaustion, especially within a couple of hours of solar noon.',
    'The temperature is extremely hot. Outdoor activity should be limited, especially within a few hours of solar noon. The risk of heat stroke may be substantial.'
  ];

  TemperatureDescription({required this.temperature, Key? key})
      : super(key: key);

  int getDescription(double temperature) {
    if (temperature < -15) {
      return 0;
    } else if (temperature < 0) {
      return 1;
    } else if (temperature < 10) {
      return 2;
    } else if (temperature < 17) {
      return 3;
    } else if (temperature < 25) {
      return 4;
    } else if (temperature < 30) {
      return 5;
    } else if (temperature < 35) {
      return 6;
    } else {
      return 7;
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
      content: Text(longDescriptions[getDescription(temperature)]),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Dismiss'),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
