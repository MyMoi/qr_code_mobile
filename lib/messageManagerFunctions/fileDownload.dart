import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:send_qr/communication/messageManager.dart';
import 'package:permission_handler/permission_handler.dart';

Future downloadFile(String url, String ivBase64, String filename) async {
  final MessageManager _messageManager = MessageManager();
  final Dio dio = Dio();
  print('Download.....');
  final Response<List<int>> response = await dio.get<List<int>>(url,
      options: Options(responseType: ResponseType.bytes));
  print('init decryption... ${DateTime.now()}');

  final iv = encrypt.IV.fromBase64(ivBase64);
  final encrypter = encrypt.Encrypter(
      encrypt.AES(_messageManager.key, mode: encrypt.AESMode.cbc));
  print('Starting decryption... ${DateTime.now()}');
  final decrypted =
      encrypter.decryptBytes(encrypt.Encrypted(response.data), iv: iv);
  print('Finished decryption... ${DateTime.now()}');
  //bool isShown = await Permission.storage.shouldShowRequestRationale;
  print(response.data);
  print(decrypted.toString());

  await Permission.storage.request();
  // Directory appDocDir = await getDownloadsDirectory();
  File(("/storage/emulated/0/Download/" + filename)).writeAsBytes(decrypted);
  print("file path :" + "/storage/emulated/0/Download/");
  //Image.file(File("/storage/emulated/0/Download/" + filename));
}

_encryptFile(contentBytes, encrypt.Key key, encrypt.IV iv) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.encrypt(contentBytes.toString(), iv: iv).bytes;
  //return content.readAsBytes();
}
