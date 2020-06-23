
import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String avatar = "";
  String name;

  bool errorUsername = false;
  bool errorAvatar = false;

  validateUsername() => errorUsername = name == null || name.isEmpty;
  validateAvatar() => errorAvatar = avatar == null || avatar.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 80,),

            // Title
            Text(
              "TimeTek",
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 20,),

            // Welcome
            Text(
              "Add your basic details",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.blueGrey
              ),
            ),

            SizedBox(height: 10,),


            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: (){
                  _chooseAvatar();
                },
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.blueGrey,
                  child: _avatar(),
                ),
              ),
            ),

            Visibility(
              visible: errorAvatar == true,
              child: Text(
                "Please choose a name",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.red
                ),
              ),
            ),

            // Email Address input
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              margin: EdgeInsets.only(top: 16, left: 16, bottom: 0, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xFF8563EA),
                  width: 2
                )
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 18
                ),
                decoration: InputDecoration(
                  hintText: "What's your name?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0)
                ),
                onChanged: (text){
                  setState(() {
                    name = text;
                    validateUsername();
                  });
                },
              ),
            ),

            Visibility(
              visible: errorUsername == true,
              child: Text(
                "Please choose a name",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.red
                ),
              ),
            ),

            SizedBox(height: 16,),

            // Login Button
            FlatButton(
              onPressed: (){

                setState(() {
                  validateAvatar();
                  validateUsername();
                });

                if(errorAvatar == false && errorUsername == false){
                  UserDataProvider().setLoggedIn(true, name: name, avatar: avatar);
                  Navigator.of(context).pushReplacementNamed(ROUTE_APP_MAIN);
                }


              },
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
                  constraints: BoxConstraints(maxWidth: 280, minHeight: 40),
                  alignment: Alignment.center,
                  child: Text(
                    "Start using TimeTek ▶",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      )
    );
  }

  _avatar(){
    if(avatar == null || avatar.isEmpty){
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Click to choose avatar",
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 15,
              color: Colors.white
            ),
          ),
        ),
      );
    } else {
      return Image.asset(
        avatar,
      );
    }
  }

  _chooseAvatar() async {
    var chosenAvatar = await Navigator.of(context).pushNamed(ROUTE_CHOOSE_AVATAR);

    if(chosenAvatar != null && chosenAvatar is String && chosenAvatar.isNotEmpty){
      setState(() {
        avatar = chosenAvatar;
        validateAvatar();
      });
    }
  }
}