import 'dart:async';

import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 2000), (){

        UserDataProvider().isLoggedIn().then((isLoggedIn){

          if(isLoggedIn){
            Navigator.of(context).pushReplacementNamed(ROUTE_HOME);
          } else {
            Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
          }

        });
      }
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "TimeTek",
        style: GoogleFonts.raleway(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}