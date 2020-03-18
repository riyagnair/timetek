import 'package:flutter/material.dart';

Future showAlert(BuildContext context, String title, String body, { Map<String, dynamic> actions }){

  List<Widget> _getActions(){
    List<Widget> acts = [];
    if(actions == null || actions.isEmpty){
      return [
        FlatButton(child: Text("Yes"), onPressed: () => Navigator.of(context).pop(true))
      ];
    } else {
      return actions
        .keys
        .map((key) => FlatButton(child: Text(key), onPressed: () => Navigator.of(context).pop(actions[key])))
        .toList(growable: false);
    }
  }

  return showDialog(
    context: context,
    builder: (ctx){
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: _getActions()
      );
    },
  );
}