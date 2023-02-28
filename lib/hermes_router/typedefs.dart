import 'dart:async' show FutureOr;

import 'package:flutter/widgets.dart';
import 'package:hermes/hermes_router/hermes_router_state.dart';

typedef HermesRouterWidgetBuilder = Widget Function(
  BuildContext context,
  HermesRouterState state,
);

typedef HermesRouterRedirect = FutureOr<String?> Function(
    BuildContext context, HermesRouterState state);
