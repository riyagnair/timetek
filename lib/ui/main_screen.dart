import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/provider/user_data.dart';
import 'package:TimeTek/ui/account/my_account_screen.dart';
import 'package:TimeTek/ui/advisor/advisor_screen.dart';
import 'package:TimeTek/ui/history/history_screen.dart';
import 'package:TimeTek/ui/home/home_screen.dart';
import 'package:TimeTek/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppMainScreen extends StatefulWidget {
  @override
  _AppMainScreenState createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      UserDataProvider().hasSlotsSet().then((set) {
        if (!set) {
          Navigator.of(context).pushNamed(ROUTE_EDIT_SLOTS);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    AssignmentDataProvider provider = Provider.of<AssignmentDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          _getTabTitle(_selectedTabIndex),
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _getTabContents(_selectedTabIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _getIcon(icon: Icons.home, text: "Home", isSelected: _selectedTabIndex == 0, onTap: () { setState(() => _selectedTabIndex = 0); },),
            _getIcon(icon: Icons.transfer_within_a_station, text: "Adviser", isSelected: _selectedTabIndex == 1, onTap: () { setState(() => _selectedTabIndex = 1); },),
            /* placeholder only */ Expanded(child: Container(height: 55, color: Colors.white.withOpacity(0.2)),),
            _getIcon(icon: Icons.view_list, text: "History", isSelected: _selectedTabIndex == 2, onTap: () { setState(() => _selectedTabIndex = 2); },),
            _getIcon(icon: Icons.account_circle, text: "Account", isSelected: _selectedTabIndex == 3, onTap: () { setState(() => _selectedTabIndex = 3); },),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(ROUTE_ADD_ASSIGNMENT);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _getIcon({
    @required IconData icon,
    @required String text,
    @required bool isSelected,
    Function onTap
  }){
    return Expanded(
      child: Container(
        height: 55,
        child: Material(
          color: Colors.white.withOpacity(0.2),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                ),

                Visibility(
                  visible: isSelected,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTabContents(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return AdviserScreen();
      case 2:
        return HistoryScreen();
      case 3:
        return MyAccountScreen();
      default:
        return Center(
          child: Text("Home Screen"),
        );
    }
  }

  String _getTabTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return "Home";
      case 1:
        return "Advisor";
      case 2:
        return "History";
      case 3:
        return "My Account";
      default:
        return "Home";
    }
  }
}
