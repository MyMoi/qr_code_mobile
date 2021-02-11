import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:send_qr/pages/connection_page.dart';
import 'package:send_qr/pages/qr_scanner.dart';
import 'package:send_qr/pages/talk_page.dart';

import 'communication/messageManager.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
    theme: ThemeData(
      brightness: Brightness.dark,
      //primarySwatch: Colors.orange,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MessageManager messageManager = MessageManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr transfer'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Scan'),
          onPressed: () {
            _openQrScanner(context);
          },
        ),
      ),
    );
  }

  _openQrScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    if (result != null) {
      print("resultaaaa: " + result);
      final resultMap = jsonDecode(result);
      await messageManager.connect(
          resultMap["host"],
          "http://192.168.1.68:3000/upload/",
          resultMap["room"],
          resultMap['key']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TalkPage(),
        ),
      );
    }
  }
}
