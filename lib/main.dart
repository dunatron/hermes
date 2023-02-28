import 'package:flutter/material.dart';
import 'package:hermes/hermes_router/hermes_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HermesRouter Demo',
      onGenerateRoute: HermesRouter.generateRoute,
    );
  }
}
