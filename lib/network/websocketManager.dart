import 'dart:async';
import 'dart:convert';
import 'package:send_qr/communication/encryption.dart' as aesCrypt;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebsocketManager {
  static final WebsocketManager _websocketManager =
      WebsocketManager._internal();
  static var _channel;
  static var url;
  static var key;
  static bool isConnected = false;
  factory WebsocketManager() {
    print('WS Start');
    //_websocketManager.init();

    return _websocketManager;
  }

  WebsocketManager._internal();

  init(_url, _key) async {
    print('WS init');
    print('url : ' + _url);
    key = _key;
    print('Ws Connect');

    if (isConnected == false) {
      _channel = IOWebSocketChannel.connect(_url);
      _channel.stream.listen((message) {
        _receiveMessage(message);
      });
      isConnected = true;
    }
    return _websocketManager;
  }

  _receiveMessage(msg) {
    print(msg);
  }

  sendText(text) {
    if (text != "")
      _channel.sink
          .add(_createJsonRequest('newText', aesCrypt.encrypt(text, key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  void disconnect() {
    _channel.sink.close(status.goingAway);
    isConnected = false;
  }

  final _receiveFenEvent = StreamController<String>.broadcast();

  Stream<String> get receiveFenEventStream =>
      _receiveFenEvent.stream; // return new party id

}
