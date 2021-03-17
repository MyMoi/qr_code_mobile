//import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
/*
void main() {
  print(decrypt('8a117aa0329689a62911c4bcbf6834a0',
      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
}
*/

final algorithm = AesCbc.with256bits(
  macAlgorithm: Hmac.sha256(),
);

//https://pub.dev/documentation/cryptography/latest/cryptography/AesCbc-class.html

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random.secure();

Future<String> decrypt(
    String content, String iv, String mac, SecretKey key) async {
  print('decriiiiiipt');
  print(content);
  print(iv);
  final decodedText = await algorithm.decrypt(
    SecretBox(base64Decode(content),
        nonce: base64Decode(iv), mac: Mac(base64Decode(mac))),
    secretKey: key,
  );

  return Future.value(utf8.decode(decodedText));
}

Future<Map<String, String>> encrypt(String content, SecretKey key) async {
  final secretText = await algorithm.encrypt(
    utf8.encode(content),
    secretKey: key,
  );

  return Future.value({
    'content': base64Encode(secretText.cipherText),
    'iv': base64Encode(secretText.nonce),
    'mac': base64Encode(secretText.mac.bytes)
  });
}

String getRandomString({int length = 32}) =>
    String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future<SecretKey> getRandomKey() async {
  //return Key.fromBase64(keyString);
  final SecretKey key = await algorithm.newSecretKey();
  print("Gen Random Key");

  return Future.value(key);
}

Future<SecretKey> getKeyFromString({keyString}) async {
  //return Key.fromBase64(keyString);

  final SecretKey key =
      await algorithm.newSecretKeyFromBytes(base64Decode(keyString));
  return Future.value(key);
}
//  final secretKey = await algorithm.newSecretKey();
//  final nonce = algorithm.newNonce();

Future<List<int>> decryptFile(
    List<int> content, String iv, String mac, SecretKey key) async {
  final decodedFile = await algorithm.decrypt(
    SecretBox(content, nonce: base64Decode(iv), mac: Mac(base64Decode(mac))),
    secretKey: key,
  );

  return Future.value(decodedFile);
}

Future<SecretBox> encryptFile(contentBytes, SecretKey key) async {
  print('Starting encryption... ${DateTime.now()}');
  final secretFile = await algorithm.encrypt(
    contentBytes,
    secretKey: key,
  );
  print('Finished encryption... ${DateTime.now()}');
  return Future.value(secretFile);
}
