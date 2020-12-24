import 'dart:async';
import 'dart:convert';
//import 'package:encrypt/encrypt.dart';
import 'package:send_qr/communication/encryption.dart' as aesCrypt;
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';

class WebsocketManager {
  static var _channel;
  final String url;
  final key;

  static bool isConnected = false;

  WebsocketManager(this.url, this.key) {
    print('Ws Connect');
    _channel = IOWebSocketChannel.connect(url);
    _channel.stream.listen((message) {
      _receiveMessage(message);
    });
  }

  _receiveMessage(msg) {
    print(msg);
    _receiveFenEvent.sink.add(msg);
  }

  void sendWs(text) {
    _channel.sink.add(text);
    print(text);
  }

  void disconnect() {
    _channel.sink.close(status.goingAway);
    isConnected = false;
    _receiveFenEvent.close();
  }

  final _receiveFenEvent = StreamController<String>.broadcast();

  Stream<String> get receiveTextEventStream =>
      _receiveFenEvent.stream; // return new party id

}
