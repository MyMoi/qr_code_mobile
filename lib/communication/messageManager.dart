//import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:send_qr/communication/encryption.dart' as aesCrypt;
import 'package:send_qr/messageManagerFunctions/fileUpload.dart';
import 'package:send_qr/network/websocketManager.dart';

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  WebsocketManager ws;
  String _wsApiUrl;
  String _fileApiUrl = "http://192.168.1.68:3000/upload/";

  String _room;
  var _key;
  List<String> messageList = [];

  factory MessageManager() => _instance;

  MessageManager._internal() {
    print("New instance of Message Manager");
  }

  Future<String> connect(wsUrl, fileUrl, roomId, key) {
    // url = "ws://192.168.1.27:8000";
    //        if (room == null) {
    if (_wsApiUrl == null) {
      _key = aesCrypt.getKeyFromString(keyString: key);
      _wsApiUrl = wsUrl;
      _room = roomId;
      ws = WebsocketManager(wsApi, _key);
      print('url : ' + _wsApiUrl);
      assert(ws != null);
      ws.receiveTextEventStream.listen((message) {
        final decodedMessage = jsonDecode(message);
        switch (decodedMessage['event']) {
          case 'newText':
            {
              String decodedText = aesCrypt.decrypt(
                  decodedMessage['body']['content'].toString(),
                  decodedMessage['body']['iv'].toString(),
                  _key);
              messageList.add(decodedText);
              _updateMessageList.sink.add(decodedText);
            }
            break;
          case 'connected':
            {
              //_systemEvent.sink.add('newConnection');
              ws.sendWs(jsonEncode({'event': 'deviceConnected'}));
              print("connected");
            }
            break;
          default:
            {
              print('unknown event');
            }
            break;
        }
      });
    }
    return Future.value('bob');
  }

  void disconnect() {
    print("mam disconnected;");
    ws.disconnect();

    // _updateMessageList.close();
    // _systemEvent.close();

    ws = null;
    _key = null;
    _wsApiUrl = null;
  }

  sendText(text) {
    if (text != "")
      ws.sendWs(_createJsonRequest('newText', aesCrypt.encrypt(text, _key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  transferSession(String _recipientUrl, String _recipientKeyBase64) {
    final _tempKey = aesCrypt.getKeyFromString(keyString: _recipientKeyBase64);
    final _ws = WebsocketManager(_recipientUrl, _tempKey);
    _ws.sendWs(_createJsonRequest(
        'connectSession',
        aesCrypt.encrypt(
            jsonEncode({'url': wsApi, 'key': _key.base64}), _tempKey)));
    _ws.disconnect();
  }

  Future sendFile() async {
    await uploadFile();
  }

  final _updateMessageList = StreamController<String>.broadcast();

  Stream<String> get updateMessageListStream =>
      _updateMessageList.stream; // return new party id

  final _systemEvent = StreamController<String>.broadcast();

  Stream<String> get systemEventStream =>
      _systemEvent.stream; // return new party id

  get wsApi => (_wsApiUrl + '/' + _room);
  get key => _key;
  get fileApiUrl => _fileApiUrl;
  get fileApi => (_fileApiUrl + _room);
  get room => _room;
}
