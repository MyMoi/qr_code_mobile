import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:send_qr/communication/messageManager.dart';

import 'package:send_qr/network/websocketManager.dart';

import 'package:send_qr/widgets/messageColumn.dart';

//import 'package:simply';

class TalkPage extends StatefulWidget {
  //final String host;

  //TalkPage({Key key, @required this.host}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TalkPageState();
}

class TalkPageState extends State<TalkPage> {
  String text = '';

  var key;
  String room;
  String url;

  Widget build(BuildContext context) {
    return Scaffold(
        body:
            //      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            //Expanded(
            //child:
            SafeArea(
      child: MessageColumn(),
    )
        //),
        /*     Container(
        decoration: BoxDecoration(
          // color: Colors.red,
          border: Border(
            left:
                Divider.createBorderSide(context, color: Colors.grey, width: 1),
          ),
        ),
        alignment: Alignment.centerRight,
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: Text("Clipboard")),
              Container(
                width: 250,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    //color: Colors.red,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text("test2"),
              ),
            ]),
      ),*/
        //]),
        );
  }
}
