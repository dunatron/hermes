# hermes

A new Flutter project.

## hermes_router

The Hermes router is responsible for performing web based routing in the flutter application

## Hermes Router Proposed Usage

### calling hermesRouter usage

```dart
context.hermesRouter('/vehicles/12/request-wof');
context.hermesRouter('/admin/yards/42/vehicles/12/add-wof');
```

### calling hermesRouterNamed usage

```dart
const queryParams = <String, String>{'sort': 'desc'};

IconButton(
    onPressed: () => context.hermesRouterNamed('Admin Vehicles Page',
        params: <String, String>{'yardId': yardId}, queryParams: queryParams),
    tooltip: 'sort ascending or descending',
    icon: const Icon(Icons.sort),
)
```

### setup HermesRouter usage

```dart
final _authentication = serviceLocator<Authentication>();

final hermes = HermesRouter(
    errorBuilder: (BuildContext context, state) => ErrorPage(error: state.error),
    redirect: (BuildContext context, state) {
        if(!_authentication.isAuthorized) {
            return '/authentication'
        }
    },
    onRouteChange: (BuildContext context, state, String location, String name) {
        print('Hermes Route location: $location');
        print('Hermes Route name: $name');
    }
    routes: [
        HermesRoute(
            path: '/authentication',
            name: 'Authentication',
            builder: (BuildContext context, state) {
                return AuthenticationPage();
            }
        ),
        // admin routes
        HermesShellRoute(
            builder: (BuildContext context, state) {
                return AdminDashboardShellPage();
            }
            routes: [
                HermesRoute(
                    path: '/admin/dashboard',
                    name: 'Admin Dashboard',
                    redirect: (BuildContext context, state) {
                        final currentUser = _authentication.currentUser()
                        if (currentUser == null || !currentUser.isAdmin) {
                            return '/authentication'
                        }
                    },
                    builder: (BuildContext context, state) {
                        return AdminDashboardPage();
                    }
                ),
                HermesRoute(
                    path: '/admin/profile',
                    name: 'Admin Profile',
                    builder: (BuildContext context, state) {
                        return AdminProfilePage();
                    }
                ),
                HermesRoute(
                    path: '/admin/yards',
                    name: 'Yards List',
                    builder: (BuildContext context, HermesRouterState state) {
                        return YardsListPage();
                    },
                    routes: [
                        HermesRoute(
                            path: ':yardId',
                            name: 'Yard Dashboard',
                            builder: (BuildContext context, state) {
                                return YardDashboardPage(
                                    yardId: state.params['yardId']!,
                                );
                            }
                            routes: [
                                HermesRoute(
                                    path: 'vehicles',
                                    name: 'Admin Vehicles Page',
                                    builder: (BuildContext context, state) {
                                        return AdminVehiclesListPage(
                                            yardId: state.params['yardId']!,
                                            asc: state.queryParams['sort'] == 'asc'
                                        );
                                    }
                                   routes: [
                                        HermesRoute(
                                            path: ':vehicleId',
                                            name: 'Admin Vehicle Details',
                                            builder: (BuildContext context, HermesRouterState state) {
                                                final yardId = state.params['vehicleId']!;
                                                final vehicleId = state.params['vehicleId']!;
                                                return AdminVehicleDetailsPage(vehicleId: id, yardId: yardId);
                                            }
                                            routes: [
                                                HermesRoute(
                                                    path: 'add-wof',
                                                    name: 'Vehicle Add Wof',
                                                    builder: (BuildContext context, HermesRouterState state) {
                                                        final id = state.params['pid']!;
                                                        return VehicleAddWofPage(vehicleId: id);
                                                    },
                                                )
                                            ]
                                        )
                                    ]
                                ),
                            ]
                        ),
                    ]
                )
            ]
        ),
        // normal user routes
        HermesShellRoute(
            builder: (context, state, child) {
                return ScaffoldWithNavPage(child: child);
            }
            routes: [
                HermesRoute(
                    path: '/',
                    name: 'Home',
                    builder: (BuildContext context, state) {
                        return HomePage();
                    }
                ),
                HermesRoute(
                    path: '/profile',
                    name: 'Profile',
                    builder: (BuildContext context, state) {
                        return ProfilePage();
                    }
                ),
                HermesRoute(
                    path: '/vehicles',
                    name: 'Vehicles',
                    builder: (BuildContext context, state) {
                        return VehiclesListPage(
                            asc: state.queryParams['sort'] == 'asc',
                        );
                    },
                    routes: [
                        HermesRoute(
                            path: ':vehicleId',
                            name: 'Vehicle Details',
                            builder: (BuildContext context, HermesRouterState state) {
                                final id = state.params['vehicleId']!;
                                return VehicleDetailsPage(id: id);
                            }
                            routes: [
                                HermesRoute(
                                    path: 'request-wof',
                                    name: 'Request WOF',
                                    builder: (BuildContext context, HermesRouterState state) {
                                        final id = state.params['vehicleId']!;
                                        return VehicleRequestWofPage(vehicleId: id);
                                    },
                                )
                            ]
                        )
                    ]
                ),
            ]
        )
    ]
);

```

## Proposed classes

`HermesRouter`: The main router class that manages all the routes and handles the navigation logic.

`HermesRouterState`: A class that holds the current state of the router, including the current route and any associated parameters or query parameters.

`HermesRoute`: A class that defines a single route in the router, including its path, name, and builder function for constructing the corresponding widget tree.

`HermesShellRoute`: A subclass of HermesRoute that represents a shell or container route that can contain other routes.

`HermesRouteMatch`: A class that represents a match between a URL and a route's path pattern, including any associated parameters and query parameters.

`HermesErrorState`: A class that represents an error state in the router, including any associated error message.

`HermesRedirectState`: A class that represents a redirect state in the router, including the target location of the redirect.

`HermesRouteObserver`: A class that observes changes to the router's state and triggers any associated callbacks, such as the onRouteChange callback.

`HermesRouteInformationParser`: A class that parses incoming URLs into HermesRouteInformation objects.

`HermesRouterDelegate`: A class that manages the integration between the Navigator and HermesRouter, including pushing new routes and populating the Navigator's stack with the appropriate widgets.

## proposed order of implementation

1. `HermesRoute`: This is the core class that defines a single route in the router. It's essential to have this class implemented first, so you can start defining your routes and their corresponding builders.
2. `HermesShellRoute`: This class builds upon HermesRoute and allows you to define nested routes. You can't have a shell route without the basic HermesRoute class.
3. `HermesRouter`: This is the main class that ties everything together. It's responsible for managing the state of the router and coordinating the rendering of routes.
4. `HermesRouterDelegate`: This class is used to integrate the router with Flutter's existing routing system. Implementing it will allow you to use Navigator to push and pop routes in your app.
5. `HermesRouterInformationParser`: This class is used to parse URLs and generate corresponding route information that can be consumed by HermesRouterDelegate. It's required for deep linking and handling external URLs.
6. `HermesRouterState`: This class represents the state of the router and is passed down to route builders. Implementing it will allow you to manage the state of your app's routing system.

It's worth noting that this order isn't set in stone, and you may find it helpful to jump around the list based on your needs and priorities. However, in general, implementing the classes in the order listed above should provide a good foundation for building out the rest of your router.
