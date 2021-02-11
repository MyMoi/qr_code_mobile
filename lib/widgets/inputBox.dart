import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:send_qr/communication/messageManager.dart';
import 'package:send_qr/pages/qr_scanner.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    Key key,
  }) : super(key: key);

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  MessageManager _messageManager;
  TextEditingController _controller;
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _messageManager = MessageManager();
  }

  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type somethings...',
                  hintStyle: TextStyle(color: Colors.white60)),
            ),
          ), //),
          //Flexible(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      //highlightColor: Colors.redAccent,
                      //hoverColor: Colors.redAccent,
                      splashColor: Colors.redAccent,

                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _controller.text = '';
                      },
                    ),
                    OutlineButton.icon(
                      onPressed: () {
                        Clipboard.getData(Clipboard.kTextPlain)
                            .then((value) => {
                                  print(value.text),
                                  if (value.text != '')
                                    {
                                      _controller.text = value.text,
                                      // isTextEmpty = false;
                                    }
                                });
                      },
                      icon: Icon(Icons.paste_outlined),
                      label: Text("Paste"),
                    ),
                  ]),
              IconButton(
                //highlightColor: Colors.redAccent,
                //hoverColor: Colors.redAccent,
                //splashColor: Colors.redAccent,

                icon: Icon(Icons.device_hub_outlined),
                onPressed: () {
                  _openQrScanner(context);
                },
              ),
              IconButton(
                //highlightColor: Colors.redAccent,
                //hoverColor: Colors.redAccent,
                //splashColor: Colors.redAccent,

                icon: Icon(Icons.attach_file),
                onPressed: () {
                  _messageManager.sendFile();
                },
              ),
              IconButton(
                onPressed: () {
                  print("value : " + _controller.text);
                  _messageManager.sendText(_controller.text);
                },
                icon: Icon(Icons.send,
                    color: // Color(
                        //0xffc5e1a5), //
                        Theme.of(context).accentColor),
              ),
            ],
          ),
          //),
        ],
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
      //await _messageManager.connect(          resultMap["host"] + '/' + resultMap["room"], resultMap['key']);
      _messageManager.transferSession(
          resultMap["host"] + '/' + resultMap["room"], resultMap['key']);
    }
  }
}
