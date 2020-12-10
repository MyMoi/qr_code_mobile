import 'package:encrypt/encrypt.dart';

/*
void main() {
  print(decrypt('8a117aa0329689a62911c4bcbf6834a0',
      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
}
*/
String decrypt(String content, String iv, String key) {
  final encrypter = Encrypter(AES(Key.fromBase64(key), mode: AESMode.cbc));
  return encrypter.decrypt(Encrypted.fromBase64(content),
      iv: IV.fromBase64(iv));
}

encrypt(String content, String key) {
  final iv = IV.fromSecureRandom(16);
  final Key _key = Key.fromBase64(key);
  print(_key.length);
  print(_key.bytes);
  final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  return {
    'content': encrypter.encrypt(content, iv: iv).base64,
    'iv': iv.base64
  };
}
