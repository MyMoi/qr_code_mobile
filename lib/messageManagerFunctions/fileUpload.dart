import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:send_qr/communication/messageManager.dart';

Future uploadFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  MessageManager _messageManager = MessageManager();
  Dio dio = Dio();

  if (result != null) {
    FormData formData = new FormData.fromMap({
      "file": MultipartFile.fromBytes(
        await _encryptFile(result.files.single.bytes, _messageManager.key),
        filename: "filename",
      ),
    });
    print(result.files.single.path);
    var response = await dio.post(_messageManager.fileApi,
        data: formData, options: Options(contentType: 'multipart/form-data'));
    print(response);
  }
  return {};
}

_encryptFile(contentBytes, encrypt.Key key) {
  final iv = encrypt.IV.fromSecureRandom(16);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.encrypt(contentBytes.toString(), iv: iv).bytes;
  //return content.readAsBytes();
}
