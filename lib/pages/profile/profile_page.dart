import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Center(
        child: Column(children: [
          ElevatedButton(
            child: Text('Home'),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ElevatedButton(
            child: Text('Stack Profile'),
            onPressed: () {
              Navigator.pushNamed(context, '/users/123');
            },
          )
        ]),
      ),
    );
  }
}
