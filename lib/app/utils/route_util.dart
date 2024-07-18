import 'package:flutter/material.dart';
import 'package:in_motion/app/constants/routing_constants.dart';
import 'package:in_motion/components/screens/home/home_screen.dart';
import 'package:in_motion/components/screens/weather_list/weather_list.dart';

class RouteUtil {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map arguments = {};
    if (settings.arguments != null) {
      arguments.clear();
      arguments = settings.arguments as Map;
    }

    switch (settings.name) {
      case RoutingConstants.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        case RoutingConstants.weatherListScreenRoute:
        return MaterialPageRoute(builder: (_) => const WeatherListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static visitHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutingConstants.homeScreenRoute,
      (route) => false,
    );
  }
  static visitWeatherListPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutingConstants.weatherListScreenRoute,
    );
  }
}
