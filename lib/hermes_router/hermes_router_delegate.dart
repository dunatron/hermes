import 'package:flutter/material.dart';
import 'package:hermes/hermes_router/hermes_router.dart';

class HermesRouterDelegate extends RouterDelegate<HermesRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HermesRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  HermesRoutePath _path = HermesRoutePath(states: []);

  HermesRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  HermesRoutePath get currentConfiguration => _path;

  @override
  Widget build(BuildContext context) {
    final states = _path.states;

    final pages = List<MaterialPage<dynamic>>.generate(
      states.length,
      (index) => MaterialPage<dynamic>(
        key: ValueKey(states[index].route.name),
        child: states[index].route.builder(context, states[index]),
        name: states[index].route.name,
        arguments: states[index].params,
      ),
    );

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        _path.states.removeLast();
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setInitialRoutePath(HermesRoutePath configuration) async {
    _path = configuration;
  }

  @override
  Future<void> setNewRoutePath(HermesRoutePath configuration) async {
    _path = configuration;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
