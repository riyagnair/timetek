import 'package:TimeTek/ui/signup_screen.dart';
import 'package:TimeTek/ui/login_screen.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTek',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.black,
        primaryColor: Color(0xFF8563EA),
        accentColor: Colors.white,
      ),

      initialRoute: ROUTE_LOGIN,
      routes: {
        ROUTE_LOGIN: (context) => LoginScreen(),
        ROUTE_SIGN_UP: (context) => SignUpScreen(),
      },

    );
  }
}

