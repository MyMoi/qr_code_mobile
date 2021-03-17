import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:send_qr/communication/messageManagerFunctions/fileDownload.dart';
import 'package:url_launcher/url_launcher.dart';

class BoxFile extends StatelessWidget {
  final String content;
  const BoxFile({
    Key key,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapDecoded = jsonDecode(content);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      // width: Double.infinite,
      decoration: BoxDecoration(
          //color: Colors.amber,
          color: Colors.white10,
          //border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(mapDecoded['filename']),
            IconButton(
              icon: Icon(Icons.download_outlined),
              onPressed: () {
                downloadFile(mapDecoded['url'], mapDecoded['iv'],
                    mapDecoded['mac'], mapDecoded['filename']);
              },
            ),
          ]),
      /*   IconButton(
                onPressed: () {},
                icon: Icon(Icons.send,
                    color: // Color(
                        //0xffc5e1a5), //
                        Theme.of(context).accentColor),
              ),*/
    );
  }
}
