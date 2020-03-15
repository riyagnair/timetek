
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This will fit into the "Home" screen, under the "My Account" tab.
class MyAccountScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        // Profile image
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(140)
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage("resources/images/chandler.jpg"),
            radius: 70,
          ),
        ),

        // Spacer
        SizedBox(
          height: 8,
        ),

        // User name
        Text(
          "Chandler Bing",
          style: GoogleFonts.raleway(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),

      ],
    );
  }

}