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
            Navigator.of(context).pushReplacementNamed(ROUTE_APP_MAIN);
          } else {
            Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
          }

        });
      }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[

          Spacer(),

          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  "resources/icon.png",
                  width: 50,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  "TimeTek",
                  style: GoogleFonts.raleway(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
            ],
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "v 1.0.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14
              ),
            ),
          )

        ],
      ),
    );
  }
}