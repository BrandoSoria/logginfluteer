import 'package:flutter/material.dart';
import 'package:logginfluteer/sign_in_screen.dart';
import 'package:logginfluteer/sign_up_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Clima',
      initialRoute: '/signin',
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
      },
    );
  }
}
