import 'package:hermes/hermes_router/hermes_router.dart';

class HermesRoutePath {
  final List<HermesRouteState> states;

  HermesRoutePath({required this.states});

  factory HermesRoutePath.fromLocation(String location) {
    final uri = Uri.parse(location);
    final segments = uri.pathSegments;

    final states = <HermesRouteState>[];

    var currentRoute = _HermesRouterDelegate.routes.firstWhere(
      (route) => route.location == '/',
    );

    for (final segment in segments) {
      if (currentRoute.routes == null) {
        throw HermesRouteNotFoundException('Invalid route: $location');
      }

      final nestedRoute = currentRoute.routes!.firstWhereOrNull(
        (route) => _matchRoute(location, currentRoute, segment),
      );

      if (nestedRoute == null) {
        throw HermesRouteNotFoundException('Invalid route: $location');
      }

      final params = _extractParams(currentRoute, segment);
      final state = HermesRouteState(route: nestedRoute, params: params);

      states.add(state);

      currentRoute = nestedRoute;
    }

    return HermesRoutePath(states: states);
  }

  @override
  String toString() {
    return '/${states.map((state) => state.route.location).join('/')}';
  }
}

bool _matchRoute(String location, HermesRoute route, String segment) {
  final routeSegments = _splitRoute(route.location);
  final locationSegments = _splitRoute(location);

  if (routeSegments.length != locationSegments.length) {
    return false;
  }

  for (var i = 0; i < routeSegments.length; i++) {
    final routeSegment = routeSegments[i];
    final locationSegment = locationSegments[i];

    if (_isParam(routeSegment)) {
      continue;
    }

    if (routeSegment != locationSegment) {
      return false;
    }
  }

  return true;
}

Map<String, String> _extractParams(HermesRoute route, String segment) {
  final routeSegments = _splitRoute(route.location);
  final segmentSegments = _splitRoute(segment);

  final params = <String, String>{};

  for (var i = 0; i < routeSegments.length; i++) {
    final routeSegment = routeSegments[i];

    if (_isParam(routeSegment)) {
      final paramName = _getParamName(routeSegment);
      final paramValue = segmentSegments[i];
      params[paramName] = paramValue;
    }
  }

  return params;
}

List<String> _splitRoute(String route) {
  return route.split('/').where((segment) => segment.isNotEmpty).toList();
}

bool _isParam(String segment) {
  return segment.startsWith(':');
}

String _getParamName(String segment) {
  return segment.substring(1);
}
