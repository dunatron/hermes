import 'package:flutter/material.dart';
import 'package:hermes/hermes_router/path_utils.dart';
import 'package:hermes/hermes_router/typedefs.dart';

/// The base class for [HermesRoute] and [HermesShellRoute].
///
/// Routes are defined in a tree such that parent routes must match the
/// current location for their child route to be considered a match. For
/// example the location "/home/user/12" matches with parent route "/home" and
/// child route "user/:userId".
///
/// To create sub-routes for a route, provide them as a [HermesRoute] list
/// with the sub routes.
///
/// For example these routes:
/// ```
/// /         => HomePage()
///   family/f1 => FamilyPage('f1')
///     person/p2 => PersonPage('f1', 'p2') ← showing this page, Back pops ↑
/// ```
///
/// Can be represented as:
///
/// ```
/// final HermesRouter _router = HermesRouter(
///   routes: <HermesRoute>[
///     GoRoute(
///       path: '/',
///       name: 'Home Page'
///       pageBuilder: (BuildContext context, HermesRouterState state) => MaterialPage<void>(
///         key: state.pageKey,
///         child: HomePage(families: Families.data),
///       ),
///       routes: <HermesRoute>[
///         GoRoute(
///           path: 'family/:fid',
///           name: 'Family Page'
///           pageBuilder: (BuildContext context, HermesRouterState state) {
///             final Family family = Families.family(state.params['fid']!);
///             return MaterialPage<void>(
///               key: state.pageKey,
///               child: FamilyPage(family: family),
///             );
///           },
///           routes: <GoRoute>[
///             HermesRoute(
///               path: 'person/:pid',
///               name: 'Person Page'
///               pageBuilder: (BuildContext context, HermesRouterState state) {
///                 final Family family = Families.family(state.params['fid']!);
///                 final Person person = family.person(state.params['pid']!);
///                 return MaterialPage<void>(
///                   key: state.pageKey,
///                   child: PersonPage(family: family, person: person),
///                 );
///               },
///             ),
///           ],
///         ),
///       ],
///     ),
///   ],
/// );
///
/// If there are multiple routes that match the location, the first match is used.
/// To make predefined routes to take precedence over dynamic routes eg. '/:id'
/// consider adding the dynamic route at the end of the routes
/// For example:
/// ```
/// final HermesRouter _router = HermesRouter(
///   routes: <HermesRoute>[
///     HermesRoute(
///       path: '/',
///       name: 'Home Page'
///       redirect: (_) => '/family/${Families.data[0].id}',
///     ),
///     HermesRoute(
///       path: '/family',
///       name: 'Family Page'
///       pageBuilder: (BuildContext context, HermesRouterState state) => ...,
///     ),
///     HermesRoute(
///       path: '/:username',
///       name: 'User Profile'
///       builder: (BuildContext context, HermesRouterState state) => ...,
///     ),
///   ],
/// );
/// ```
/// In the above example, if /family route is matched, it will be used.
/// else /:username route will be used.
/// ///

@immutable
abstract class RouteBase {
  const RouteBase._({
    this.routes = const <RouteBase>[],
  });

  /// The list of child routes associated with this route.
  final List<RouteBase> routes;
}

class HermesRoute extends RouteBase {
  HermesRoute({
    required this.path,
    required this.name,
    required this.builder,
    this.redirect,
    super.routes = const <RouteBase>[],
  }) : super._() {
    // cache the path regexp and parameters
    _pathRE = patternToRegExp(path, pathParams);
  }

  final String name;
  final String path;
  final HermesRouterWidgetBuilder builder;

  final HermesRouterRedirect? redirect;

  RegExpMatch? matchPatternAsPrefix(String loc) =>
      _pathRE.matchAsPrefix(loc) as RegExpMatch?;

  /// Extract the path parameters from a match.
  Map<String, String> extractPathParams(RegExpMatch match) =>
      extractPathParameters(pathParams, match);

  final List<String> pathParams = <String>[];

  @override
  String toString() {
    return 'GoRoute(name: $name, path: $path)';
  }

  late final RegExp _pathRE;
}
