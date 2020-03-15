import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/ui/home/home_screen.dart';
import 'package:TimeTek/ui/login_screen.dart';
import 'package:TimeTek/ui/signup_screen.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssignmentDataProvider(),),
        ChangeNotifierProvider(create: (_) => UserDataProvider(),),
        // space to add more providers later.
      ],
      child: MaterialApp(
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
          ROUTE_HOME: (context) => HomeScreen(),
        },

      ),
    );
  }
}

