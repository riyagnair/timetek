import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/ui/account/my_account_screen.dart';
import 'package:TimeTek/ui/history_screen.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedTabIndex = 0;

  @override
  void initState() {

    Future.delayed(Duration.zero, (){
      UserDataProvider().hasSlotsSet().then((set){
        if(!set){
          Navigator.of(context).pushNamed(ROUTE_EDIT_SLOTS);
        } else {
          Provider.of<AssignmentDataProvider>(context).loadAssignments();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          _getTabTitle(_selectedTabIndex),
          style: GoogleFonts.raleway(textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _getTabContents(_selectedTabIndex)
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
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), title: Text("Advisor"),),
          BottomNavigationBarItem(icon: Icon(Icons.history), title: Text("History"),),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("My Account"),),
        ],

      ),

      floatingActionButton: Visibility(
        visible: _selectedTabIndex != 3,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            Navigator.of(context).pushNamed(ROUTE_ADD_ASSIGNMENT);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _getTabContents(int selectedIndex){
    switch(selectedIndex){
      case 0: return Center(child:Text("Home Screen"));
      case 1: return Center(child:Text("Advisor Screen"));
      case 2: return HistoryScreen();
      case 3: return MyAccountScreen();
      default: return Center(child:Text("Home Screen"),);
    }
  }

  String _getTabTitle(int selectedIndex){
    switch(selectedIndex){
      case 0: return "Home";
      case 1: return "Advisor";
      case 2: return "History";
      case 3: return "My Account";
      default: return "Home";
    }
  }
}