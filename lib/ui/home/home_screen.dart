import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "Dashboard",
          style: GoogleFonts.raleway(textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Container(
        child: Center(
          child: Text("Body"),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _selectedTabIndex = index;
          });
        },
        currentIndex: _selectedTabIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home"),),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text("Calendar"),),
          BottomNavigationBarItem(icon: Icon(Icons.history), title: Text("History"),),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("My Account"),),
        ],

      ),

      floatingActionButton: Visibility(
        visible: _selectedTabIndex != 3,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}