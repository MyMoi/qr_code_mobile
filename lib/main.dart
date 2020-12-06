import 'package:flutter/material.dart';

import 'package:send_qr/pages/connection_page.dart';
import 'package:send_qr/pages/qr_scanner.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConnectedPage(result)),
      );
    }
  }
}
