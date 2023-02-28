import 'package:flutter/material.dart';

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

abstract class RouteBase {
  const RouteBase._({
    this.routes = const <RouteBase>[],
  });

  /// The list of child routes associated with this route.
  final List<RouteBase> routes;
}

class HermesRoute {
  final String name;
  final String path;
  final WidgetBuilder builder;
  final List<HermesRoute> routes;

  HermesRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.routes = const [],
  });
}
