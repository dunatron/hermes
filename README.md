# hermes

A new Flutter project.

## hermes_router

builder: (BuildContext context, GoRouterState state) {

                      return NZTAVehicleDetailsPage(
                        id: id,
                      );
                    },

```dart
final hermes = HermesRouter(
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    redirect: (context, state) { },
    routes: [
        HermesRoute(
            location: '/',
            name: 'Home',
            builder: () {
                return HomePage();
            }
            routes: [
                HermesRoute(
                    location: '/profile',
                    name: 'Profile',
                    builder: (context, state) {
                        return ProfilePage();
                    }
                ),
                HermesRoute(
                    location: '/vehicles',
                    name: 'Vehicles',
                    builder: (context, state) {
                        return ProfilePage();
                    },
                    routes: [
                        HermesRoute(
                            location: ':id',
                            name: 'Vehicle Details',
                            builder: (context, state) {
                                final id = state.params['pid']!;
                                return VehicleDetailsPage(id: id);
                            }
                        )
                    ]
                ),
            ]
        )
    ]
);
```

# ToDo

1. Create a HermesRouter class that takes in the following parameters:

   - errorBuilder - A function that takes in a BuildContext and a HermesRouteState and returns a widget to display in case of an error.
   - redirect - A function that takes in a BuildContext and a HermesRouteState and performs a redirect to another route.
   - routes - A list of HermesRoute objects that define the routes for the application.

2. Create a HermesRoute class that takes in the following parameters:

   - location - A string representing the location of the route. This can include parameters in the form of :paramName.
   - name - A string representing the name of the route.
   - builder - A function that takes in a BuildContext and a HermesRouteState and returns the widget to display for the route.
   - routes - An optional list of HermesRoute objects representing child routes of this route.

3. Implement the HermesRouter class by:

- Storing the error builder and redirect functions as class variables.
- Storing the routes as a list of HermesRoute objects.
- Implementing a navigateTo function that takes in a BuildContext and a string representing the location to navigate to. This function should parse the location to find the appropriate route and push it onto the navigator stack.
- Implementing an onGenerateRoute function that takes in a RouteSettings object and returns the appropriate PageRoute for the requested route. This function should also handle any redirects and error pages.

4. Implement the HermesRoute class by:

- Storing the location, name, builder, and routes as class variables.
- Implementing a matches function that takes in a string representing a location and returns true if the route matches the location.
- Implementing a parseParams function that takes in a string representing a location and returns a map of parameter names to values.
