
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseAvatarScreen extends StatelessWidget{

  final list = [
      "resources/images/avatars/avatar_01.png",
      "resources/images/avatars/avatar_02.png",
      "resources/images/avatars/avatar_03.png",
      "resources/images/avatars/avatar_04.png",
      "resources/images/avatars/avatar_05.png",
      "resources/images/avatars/avatar_06.png",
      "resources/images/avatars/avatar_07.png",
      "resources/images/avatars/avatar_08.png",
      "resources/images/avatars/avatar_09.png",
      "resources/images/avatars/avatar_10.png",
      "resources/images/avatars/avatar_11.png",
      "resources/images/avatars/avatar_12.png",
      "resources/images/avatars/avatar_13.png",
      "resources/images/avatars/avatar_14.png",
      "resources/images/avatars/avatar_15.png",
      "resources/images/avatars/avatar_16.png",
      "resources/images/avatars/avatar_17.png",
      "resources/images/avatars/avatar_18.png",
      "resources/images/avatars/avatar_19.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // Title
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 50, right: 16, bottom: 16, left: 16),
                child: Text(
                  "◀ Choose your Avatar",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                padding: EdgeInsets.all(4),
                children: List.generate(
                  list.length,
                  (index){
                    return InkWell(
                      onTap: () => Navigator.pop(context, list[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white12
                        ),
                        child: Image.asset(
                          list[index],
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Avatars generated from getavataaars.com",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.white54
                ),
              ),
            )

          ],
        ),
      )
    );
  }
}