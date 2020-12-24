import 'package:encrypt/encrypt.dart';

/*
void main() {
  print(decrypt('8a117aa0329689a62911c4bcbf6834a0',
      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
}
*/
String decrypt(String content, String iv, Key key) {
  print('decriiiiiipt');
  print(content);
  print(iv);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  return encrypter.decrypt(Encrypted.fromBase64(content),
      iv: IV.fromBase64(iv));
}

encrypt(String content, Key key) {
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  return {
    'content': encrypter.encrypt(content, iv: iv).base64,
    'iv': iv.base64
  };
}

Key getRandomKey() {
  final Key key = Key.fromSecureRandom(32);

  //'7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'); // Key.fromSecureRandom(256);

  //print(decrypt('8a117aa0329689a62911c4bcbf6834a0',      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
  //print(encrypt("content", key));
  return key;
}

String getRandomString({int length = 32}) {
  return SecureRandom(length).base64;
}

Key getKeyFromString({keyString}) {
  return Key.fromBase64(keyString);
}
