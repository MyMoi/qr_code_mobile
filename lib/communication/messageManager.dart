//import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:send_qr/communication/encryption.dart' as aesCrypt;
import 'package:send_qr/network/websocketManager.dart';

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  WebsocketManager ws;
  String url;
  String room;
  var key;
  List<String> messageList = [];

  factory MessageManager() => _instance;

  MessageManager._internal() {
    print("New instance of Message Manager");
  }

  Future<String> connect(_url, _key) {
    // url = "ws://192.168.1.27:8000";
//        if (room == null) {
    if (url == null) {
      key = aesCrypt.getKeyFromString(keyString: _key);
      url = _url;
      ws = WebsocketManager(url, key);
      print('url : ' + url);
      assert(ws != null);
      ws.receiveTextEventStream.listen((message) {
        final decodedMessage = jsonDecode(message);
        if (decodedMessage['event'] == 'newText') {
          String decodedText = aesCrypt.decrypt(
              decodedMessage['body']['content'].toString(),
              decodedMessage['body']['iv'].toString(),
              key);
          messageList.add(decodedText);
          _updateMessageList.sink.add(decodedText);
        } else if (decodedMessage['event'] == 'newConnection') {
          _systemEvent.sink.add('newConnection');
          print("new connection.");
        }
      });
    }
    return Future.value('bob');
  }

  void disconnect() {
    ws.disconnect();

    _updateMessageList.close();
    _systemEvent.close();
  }

  sendText(text) {
    if (text != "")
      ws.sendWs(_createJsonRequest('newText', aesCrypt.encrypt(text, key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  final _updateMessageList = StreamController<String>.broadcast();

  Stream<String> get updateMessageListStream =>
      _updateMessageList.stream; // return new party id

  final _systemEvent = StreamController<String>.broadcast();

  Stream<String> get systemEventStream =>
      _systemEvent.stream; // return new party id

}
