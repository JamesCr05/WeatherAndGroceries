import 'package:flutter/material.dart';
import 'weather/weather.dart';
import 'groceries/groceries.dart';
import 'groceries/recipes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Metric());
}

class Metric extends StatelessWidget {
  const Metric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/weather',
        routes: {
          '/weather': (context) => const Weather(),
          '/groceries': (context) => const Groceries(),
          '/recipes': (context) => const Recipes(),
        });
  }
}
