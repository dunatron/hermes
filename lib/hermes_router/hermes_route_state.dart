import 'package:hermes/hermes_router/hermes_router.dart';

class HermesRouteState {
  final HermesRoute route;
  final Map<String, String> params;
  late HermesRouteState child;

  HermesRouteState(this.route, this.params, {HermesRouteState? child}) {
    if (child != null) {
      this.child = child;
    }
  }

  String get location {
    final parentLocation = child.location != '/' ? child.location : '';
    final path = route.buildRoute(parentLocation);
    final queryString = params.isNotEmpty
        ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';

    return '$path$queryString';
  }

  bool get hasChild => child.route.location != '';

  HermesRouteState? findChild(String path) {
    if (hasChild) {
      final childState = child.route.parseRoute(path);
      if (childState != null) {
        return childState;
      }
    }
    return null;
  }
}
