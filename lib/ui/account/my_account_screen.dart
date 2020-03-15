
import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/util/constants.dart';
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
        SizedBox(height: 8),

        // User name
        Text(
          "Chandler Bing",
          style: GoogleFonts.raleway(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),

        // Spacer
        SizedBox(height: 32),

        // Button: Edit Availability Slots
        _profileButton("Edit Availability Slots", () => Navigator.of(context).pushNamed(ROUTE_EDIT_SLOTS)),

        // Spacer
        SizedBox(height: 16),

        // Button: Log Out
        _profileButton("Log out", () => _logout(context), showArrow: false),


      ],
    );
  }

  _profileButton(String title, Function action, {showArrow = true}){
    return InkWell(
      onTap: () => action(),
      child: Container(
        color: Colors.white.withOpacity(0.2),
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 16
              ),
            ),
            Spacer(),
            Visibility(
              visible: showArrow,
              child: Icon(Icons.arrow_right)
            )
          ],
        ),
      ),
    );
  }

  _logout(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text("Log out?"),
          content: Text("Do you want to log out of TimeTek?"),
          actions: <Widget>[
            FlatButton(child: Text("Yes"), onPressed: () => Navigator.of(ctx).pop(true)),
            FlatButton(child: Text("No"), onPressed: () => Navigator.of(ctx).pop(false)),
          ],
        );
      },
    );

    if(result){
      UserDataProvider().setLoggedIn(false).then((_){
        Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
      });
    }
  }

}