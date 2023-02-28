import 'package:flutter/material.dart';
import 'package:hermes/hermes_router/hermes_router.dart';

class HermesRoute {
  final String location;
  final String name;
  final WidgetBuilder builder;
  final List<HermesRoute> routes;

  HermesRoute({
    required this.location,
    required this.name,
    required this.builder,
    this.routes = const [],
  });

  HermesRouteState? parseRoute(String path) {
    final uri = Uri.parse(path);
    final uriSegments = uri.pathSegments;

    if (uriSegments.length != 0 && uriSegments[0] == location.substring(1)) {
      var params = <String, String>{};
      var childState =
          HermesRouteState(HermesRoute(location: '', name: ''), {});

      // check if the path has any child routes
      if (uriSegments.length > 1) {
        for (var i = 1; i < uriSegments.length; i++) {
          final segment = uriSegments[i];
          final child = routes.firstWhereOrNull(
            (r) => r.canHandleSegment(segment),
          );
          if (child == null) {
            return null;
          }

          final childStateResult = child.parseRoute('/$segment');
          if (childStateResult == null) {
            return null;
          }

          childState = HermesRouteState(child, childStateResult.params,
              child: childState);
        }
      }

      // parse any query parameters
      if (uri.queryParameters.isNotEmpty) {
        uri.queryParameters.forEach((key, value) {
          params[key] = value;
        });
      }

      return HermesRouteState(this, params, child: childState);
    }

    return null;
  }

  String buildRoute(String? parent) {
    final pathSegments = [
      if (parent != null && parent.isNotEmpty) parent.substring(1)
    ]..addAll(locationSegments);

    return '/${pathSegments.join('/')}${queryString}';
  }

  bool canHandleSegment(String segment) {
    return routes.any((route) => route.location == ':$segment');
  }

  List<String> get locationSegments {
    return location.split('/').where((s) => s.isNotEmpty).toList();
  }

  String get queryString {
    return routes.isNotEmpty
        ? '?${routes.map((route) => route.queryString).join('&')}'
        : '';
  }
}
