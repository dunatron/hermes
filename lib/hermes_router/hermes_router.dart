import 'package:flutter/material.dart';

class HermesRouter {
  final List<HermesRoute> routes;
  final Widget Function(BuildContext context, HermesRouteState state)?
      errorBuilder;
  final void Function(BuildContext context, HermesRouteState state)? redirect;

  HermesRouter({
    required this.routes,
    this.errorBuilder,
    this.redirect,
  });

  RouteInformationParser<HermesRoutePath> get routeInformationParser {
    return _HermesRouteInformationParser(routes);
  }

  RouterDelegate<HermesRoutePath> routerDelegate({
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    return _HermesRouterDelegate(routes, navigatorKey, errorBuilder, redirect);
  }
}

class HermesRoutePath {
  final HermesRoute route;
  final String? id;

  HermesRoutePath({required this.route, this.id});

  static HermesRoutePath fromRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    // If the route doesn't match any of the above cases, return the 404 route
    return HermesRoutePath.unknown();
  }

  static HermesRoutePath unknown() => HermesRoutePath(
      route: HermesRoute(location: '/404', name: '404 Page'), id: null);

  RouteInformation toRouteInformation() {
    switch (route) {
      default:
        return const RouteInformation(location: '/404');
    }
  }

  @override
  String toString() {
    return 'HermesRoutePath{route: $route, id: $id}';
  }
}

class HermesRoute {
  final String location;
  final String name;
  final Widget Function(BuildContext context, HermesRouteState state)? builder;
  final List<HermesRoute>? routes;

  HermesRoute({
    required this.location,
    required this.name,
    this.builder,
    this.routes,
  });
}

class HermesRouteState {
  final HermesRoute route;
  final Map<String, String> params;

  HermesRouteState({required this.route, required this.params});
}
