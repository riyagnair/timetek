
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[

          Container(
            height: 80,
          ),

          // Title
          Container(
            padding: const EdgeInsets.only(left: 16),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "TimeTek",
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            )
          ),

          Spacer(),

          // Welcome
          Container(
            padding: const EdgeInsets.only(left: 16),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Sign Up",
              style: GoogleFonts.raleway(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          // User's Name input
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color(0xFF8563EA),
                width: 2
              )
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.raleway(),
              decoration: InputDecoration(
                hintText: "Name",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0)
              ),
            ),
          ),

          // Email Address input
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color(0xFF8563EA),
                width: 2
              )
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.raleway(),
              decoration: InputDecoration(
                hintText: "Email Address",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0)
              ),
            ),
          ),

          // Sign Up Button
          FlatButton(
            onPressed: (){},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90)
            ),
            padding: EdgeInsets.all(0),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Color(0xFFB4A5FE), Color(0xFF8563EA) ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 180, minHeight: 50),
                alignment: Alignment.center,
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),

          Spacer(),

          // Don't have an account?
          Text(
            "Already have an account?",
            style: GoogleFonts.raleway(
              fontSize: 16
            ),
          ),

          // Sign Up link
          Padding(
            padding: const EdgeInsets.all(4),
            child: FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(
                "Log in",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Color(0xFF8563EA),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

        ],
      )
    );
  }

}