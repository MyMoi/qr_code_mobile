import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:send_qr/communication/encryption.dart';
import 'package:send_qr/communication/messageManager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../messageManager.dart';

//import 'package:cryptography/cryptography.dart';

Future downloadFile(
    String url, String ivBase64, String macBase64, String filename) async {
  final MessageManager _messageManager = MessageManager();
  //final Dio dio = Dio();
  print('Download.....');
  //final Response<List<int>> response = await
/*
  dio
      .get<List<int>>(url, options: Options(responseType: ResponseType.bytes))
      .then((response) {
  });
  */
  http.get(Uri.parse(url)).then((response) {
    print('init decryption... ${DateTime.now()}');

    print('Starting decryption... ${DateTime.now()}');

    decryptFile(response.bodyBytes, ivBase64, macBase64, _messageManager.key)
        .then((decrypted) => {
              print('Finished decryption... ${DateTime.now()}'),
              saveFile(decrypted, filename),
            });
  });
}

void saveFile(List<int> decrypted, String filename) async {
  await Permission.storage.request();
  // Directory appDocDir = await getDownloadsDirectory();
  File(("/storage/emulated/0/Download/" + filename)).writeAsBytes(decrypted);
  print("file path :" + "/storage/emulated/0/Download/");
}
