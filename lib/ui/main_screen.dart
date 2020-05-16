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
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AppMainScreen extends StatefulWidget {
  @override
  _AppMainScreenState createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedTabIndex = 0;

  // remember the previous tab before listening to voice.
  // After the voice input is done, restore the tab.
  int _previousTabIndex = 0;

  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String recognizedWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
      onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      UserDataProvider().hasSlotsSet().then((set) {
        if (!set) {
          Navigator.of(context).pushNamed(ROUTE_EDIT_SLOTS);
        }
      });

      initSpeechState();

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    AssignmentDataProvider provider = Provider.of<AssignmentDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Row(
          children: <Widget>[
            Opacity(
              opacity: 0.4,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  "resources/icon.png",
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            Text(
              _getTabTitle(_selectedTabIndex),
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          _hasSpeech ? IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () => Navigator.of(context).pushNamed(ROUTE_ADD_ASSIGNMENT)
          ) : Container()
        ],
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
        onPressed: !_hasSpeech
          ? () => Navigator.of(context).pushNamed(ROUTE_ADD_ASSIGNMENT)
          : !speech.isListening ? startListening : null,
        child: !_hasSpeech ? Icon(Icons.add) : Icon(Icons.mic),
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
      case 99:
        return _voiceInputUI();
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

  Widget _voiceInputUI(){
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.mic,
              size: 60,
              color: speech.isListening ? Colors.red.withOpacity(0.7) : Colors.white.withOpacity(0.5),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Speak out loud. For example, you can say\n\"Add Systems Engineering for 12 hours with description include diagrams for processors\"",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (){
                  if(lastError != null && lastError.isNotEmpty){
                    return "Oops! Didn't catch that!";
                  } else if(recognizedWords != null && recognizedWords.isNotEmpty){
                    return "\"$recognizedWords\"";
                  } else return "listening...";
                }(),
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 30
                ),
              ),
            ),

            Visibility(
              visible: !speech.isListening && recognizedWords != null && recognizedWords.isNotEmpty,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  setState(() {
                    _selectedTabIndex = _previousTabIndex;
                  });
                  Navigator.of(context).pushNamed(ROUTE_ADD_ASSIGNMENT, arguments: recognizedWords);
                },
                child: Text("Add Assignment"),
              ),
            ),

            SizedBox(
              height: 50,
            ),


            FlatButton(
              onPressed: (){
                setState(() {
                  speech.cancel();
                  _selectedTabIndex = _previousTabIndex;
                });
              },
              child: Text("Cancel"),
            )

          ],
        ),
      ),
    );
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }

  void startListening() {
    recognizedWords = "";
    lastError = "";
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 10),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true);
    setState(() {
      if(_selectedTabIndex != 99){
        _previousTabIndex = _selectedTabIndex;
      }
      _selectedTabIndex = 99;
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      recognizedWords = "${result.recognizedWords}";
      debugPrint("$recognizedWords");
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    setState(() {
      lastStatus = "$status";
      debugPrint("$lastStatus");
    });
  }
}
