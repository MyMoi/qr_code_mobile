import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:send_qr/communication/messageManager.dart';

Future uploadFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  MessageManager _messageManager = MessageManager();
  Dio dio = Dio();

  if (result != null) {
    final iv = encrypt.IV.fromSecureRandom(16);
    print(result.files.single.bytes);
    FormData formData = new FormData.fromMap({
      "file": MultipartFile.fromBytes(
        await _encryptFile(await File(result.files.single.path).readAsBytes(),
            _messageManager.key, iv),
        filename: "filename",
      ),
    });
    print(result.files.single.path);
    var response = await dio.post(_messageManager.fileUploadApi,
        data: formData, options: Options(contentType: 'multipart/form-data'));
    print(response.data['filename']);
    return {
      'name': response.data['filename'],
      'iv': iv,
      'originFilename': result.files.single.name
    };
  }
}

_encryptFile(contentBytes, encrypt.Key key, encrypt.IV iv) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.encryptBytes(contentBytes, iv: iv).bytes;
  //return content.readAsBytes();
}
