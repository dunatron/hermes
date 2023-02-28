import 'package:flutter/material.dart';

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
