
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

        // Profile pic
        ClipOval(
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 120,
            height: 120,
            color: Colors.blueGrey,
            child: FutureBuilder(
              future: UserDataProvider().getAvatar(),
              builder: (_, AsyncSnapshot<String> snapshot) {
                if(snapshot.hasData){
                  return Image.asset(snapshot.data);
                } else {
                  return CircleAvatar(
                    child: Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Colors.black,
                    ),
                    radius: 60,
                  );
                }
              },
            ),
          ),
        ),

        // Spacer
        SizedBox(height: 8),

        FutureBuilder(
          future: UserDataProvider().getName(),
          builder: (_, AsyncSnapshot<String> snapshot) {
            if(snapshot.hasData){
              return Text(
                snapshot.data,
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              );
            } else {
              return Text(
                "",
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              );
            }
          },
        ),

        // User name

        // Spacer
        SizedBox(height: 32),

        // Button: Edit Availability Slots
        _profileButton("Edit Availability Slots", () => Navigator.of(context).pushNamed(ROUTE_EDIT_SLOTS)),

        // Spacer
        SizedBox(height: 16),

        // Button: Log Out
        _profileButton("Log out", () => _logout(context), showArrow: false),

        Spacer(),

        Opacity(
          opacity: 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Image.asset(
                  "resources/icon.png",
                  width: 20,
                  height: 20,
                ),
              ),
              Text(
                "TimeTek v1.0",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 50,),

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
        UserDataProvider().clearAll();
        Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
      });
    }
  }

}