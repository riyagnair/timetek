import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/ui/account/edit_slots_screen.dart';
import 'package:TimeTek/ui/assignment/add_assignment_screen.dart';
import 'package:TimeTek/ui/choose_avatar.dart';
import 'package:TimeTek/ui/login_screen.dart';
import 'package:TimeTek/ui/main_screen.dart';
import 'package:TimeTek/ui/signup_screen.dart';
import 'package:TimeTek/ui/splash_screen.dart';
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
        // space to add more providers later.
      ],
      child: MaterialApp(
        title: 'TimeTek',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          canvasColor: Colors.black,
          primaryColor: Color(0xFF8563EA),
          accentColor: Colors.white,
        ),

        initialRoute: ROUTE_SPLASH,
        routes: {
          ROUTE_SPLASH: (context) => SplashScreen(),
          ROUTE_LOGIN: (context) => LoginScreen(),
          ROUTE_SIGN_UP: (context) => SignUpScreen(),
          ROUTE_APP_MAIN: (context) => AppMainScreen(),
          ROUTE_EDIT_SLOTS: (context) => EditSlotsScreen(),
          ROUTE_ADD_ASSIGNMENT: (context) => AddAssignmentScreen(),
          ROUTE_CHOOSE_AVATAR: (context) => ChooseAvatarScreen(),
        },

      ),
    );
  }
}

