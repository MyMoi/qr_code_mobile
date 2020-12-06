import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:send_qr/network/websocketManager.dart';
import 'package:send_qr/widgets/history_list.dart';

class ConnectedPage extends StatefulWidget {
  final String message;

  ConnectedPage(this.message);

  @override
  State<StatefulWidget> createState() => ConnectedPageState();
}

class ConnectedPageState extends State<ConnectedPage> {
  var qrText = '';
  bool isTextEmpty = true;
  TextEditingController _controller;
  var url;
  var ws;
  void initState() {
    super.initState();
    _controller = TextEditingController();
    url = ('ws://' +
        jsonDecode(widget.message)['host'] +
        '/' +
        jsonDecode(widget.message)['room']);
    ws = WebsocketManager();
    ws.init(url, jsonDecode(widget.message)['key']);
  }

  void dispose() {
    _controller.dispose();
    ws.disconnect();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      //expands: true,
                      minLines: 1,
                      maxLines: null,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a text to send',
                      ),
                      onChanged: (value) {
                        if ((_controller.text == '') != (isTextEmpty)) {
                          setState(() {
                            isTextEmpty = (_controller.text == '');
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () {
                          // Scaffold.of(context).showBottomSheet(),
                          if (isTextEmpty) {
                            //displayModalBottomSheet(context);
                            Clipboard.getData(Clipboard.kTextPlain)
                                .then((value) => {
                                      print(value.text),
                                      if (value.text != '')
                                        {
                                          setState(() {
                                            _controller.text = value.text;
                                            isTextEmpty = false;
                                          }),
                                        }
                                    });
                          } else {
                            Clipboard.setData(
                                ClipboardData(text: _controller.text));
                          }
                        },
                        icon: isTextEmpty
                            ? Icon(Icons.content_paste)
                            : Icon(Icons.content_copy),
                        label: isTextEmpty ? Text('Paste') : Text('Copy'),
                      ),
                      FlatButton.icon(
                        onPressed: () {
                          // Scaffold.of(context).showBottomSheet(),
                          setState(() {
                            _controller.text = '';
                            isTextEmpty = true;
                          });
                        },
                        icon: Icon(Icons.clear_all),
                        label: Text('Clear'),
                      ),
                      IconButton(
                        onPressed: () {
                          ws.sendText(_controller.text);
                        },
                        icon: Icon(Icons.send),
                        //label: Text('Send'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              child: HistoryListWidget(
            textHistory: [widget.message, "cde"],
          )),
        ]),
      ),
    );
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.content_paste),
                    title: Text('Paste'),
                    onTap: () => {}),
                ListTile(
                  leading: Icon(Icons.keyboard_arrow_down),
                  title: Text('Replace'),
                  onTap: () => {
                    Navigator.pop(context),
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cancel'),
                  onTap: () => {
                    Navigator.pop(context),
                  },
                ),
              ],
            ),
          );
        });
  }
}
