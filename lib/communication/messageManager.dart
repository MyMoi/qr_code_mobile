//import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:send_qr/communication/encryption.dart' as aesCrypt;
import 'package:send_qr/model/messageClass.dart';
import 'package:send_qr/network/websocketManager.dart';

import 'messageManagerFunctions/fileDownload.dart';
import 'messageManagerFunctions/fileUpload.dart';

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  WebsocketManager ws;
  String _wsApiUrl;
  String _fileApiUrl;

  String _room;
  SecretKey _key;
  SecretKeyData _keyData;
  List<Message> messageList = [];

  factory MessageManager() => _instance;

  MessageManager._internal() {
    print("New instance of Message Manager");
  }

  Future<String> connect(wsUrl, fileUrl, roomId, key) async {
    // url = "ws://192.168.1.27:8000";
    //        if (room == null) {
    if (_wsApiUrl == null) {
      _key = await aesCrypt.getKeyFromString(keyString: key);
      _keyData = await _key.extract();
      _wsApiUrl = wsUrl;
      _fileApiUrl = fileUrl;
      _room = roomId;
      ws = WebsocketManager(wsApi, _key);
      print('url : ' + _wsApiUrl);
      assert(ws != null);
      ws.receiveTextEventStream.listen((message) {
        final decodedMessage = jsonDecode(message);
        switch (decodedMessage['event']) {
          case 'newText':
            {
              aesCrypt
                  .decrypt(
                      decodedMessage['body']['content'].toString(),
                      decodedMessage['body']['iv'].toString(),
                      decodedMessage['body']['mac'].toString(),
                      _key)
                  .then((decodedText) {
                messageList.add(Message(MessageType.text, decodedText));

                _updateMessageList.sink.add(decodedText);
              });
            }
            break;
          case 'connected':
            {
              //_systemEvent.sink.add('newConnection');
              ws.sendWs(jsonEncode({'event': 'deviceConnected'}));
              print("connected");
            }
            break;
          case 'newFile':
            {
              aesCrypt
                  .decrypt(
                      decodedMessage['body']['content'].toString(),
                      decodedMessage['body']['iv'].toString(),
                      decodedMessage['body']['mac'].toString(),
                      _key)
                  .then((decodedText) {
                messageList.add(Message(MessageType.file, decodedText));
                _updateMessageList.sink.add(decodedText);
                /*           final mapDecoded = jsonDecode(decodedText);
                downloadFile(mapDecoded['url'], mapDecoded['iv'],
                    mapDecoded['mac'], mapDecoded['filename']);*/
              });
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

  sendText(text) async {
    if (text != "")
      ws.sendWs(
          _createJsonRequest('newText', await aesCrypt.encrypt(text, _key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  transferSession(String _recipientUrl, String _recipientKeyBase64) async {
    final _tempKey = aesCrypt.getKeyFromString(keyString: _recipientKeyBase64);
    final _ws = WebsocketManager(_recipientUrl, _tempKey);
    _ws.sendWs(_createJsonRequest(
        'connectSession',
        await aesCrypt.encrypt(
            jsonEncode({
              'wsHost': _wsApiUrl,
              'fileHost': fileApiUrl,
              'room': room,
              'key': base64Encode(keyData.bytes),
            }),
            await _tempKey)));
    _ws.disconnect();
  }

  Future sendFile() async {
    uploadFile().then((value) async {
      ws.sendWs(_createJsonRequest(
          'newFile',
          await aesCrypt.encrypt(
              jsonEncode({
                'url': (fileDownloadApi + '/' + value['name']),
                'iv': value['iv'],
                'mac': value['mac'],
                'filename': value['originFilename']
              }),
              _key)));
    });
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
  get fileUploadApi => (_fileApiUrl + '/upload/' + _room);
  get fileDownloadApi => (_fileApiUrl + '/download/' + _room);
  get keyData => _keyData;
  get room => _room;
}
