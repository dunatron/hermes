import 'package:flutter/material.dart';
import 'package:hermes/pages/error/error.dart';
import 'package:hermes/pages/home/home.dart';
import 'package:hermes/pages/profile/profile_page.dart';

class HermesRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final List<String> pathSegments = settings.name!.split('/');
    if (pathSegments[0] != '') {
      return null;
    }

    switch (pathSegments[1]) {
      case '':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'users':
        if (pathSegments.length == 3) {
          final String id = pathSegments[2];
          return MaterialPageRoute(builder: (_) => ProfilePage(id: id));
        }
        break;
    }

    return MaterialPageRoute(builder: (_) => const ErrorPage());
  }
}
