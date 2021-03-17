import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:send_qr/communication/encryption.dart';

//import 'package:encrypt/encrypt.dart' as encrypt;
import '../messageManager.dart';

Future uploadFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  MessageManager _messageManager = MessageManager();
  //Dio dio = Dio();

  if (result != null) {
    //  print("result : " + result.files.single.bytes.toString());
    final encrypted = await encryptFile(
        await File(result.files.single.path).readAsBytes(),
        _messageManager.key);

    // FormData formData = new FormData.fromMap({
    //   "file": MultipartFile.fromBytes(
    //await _encryptFile(result.files.single.bytes, _messageManager.key, iv),
    //     encrypted.cipherText,
    //     filename: "filename",
    //  ),
    //});
    // print(result.files.single.path);
    //var response = await dio.post(_messageManager.fileUploadApi,
    //    data: formData, options: Options(contentType: 'multipart/form-data'));

    var req =
        http.MultipartRequest('POST', Uri.parse(_messageManager.fileUploadApi));
    req.files.add(http.MultipartFile.fromBytes('file', encrypted.cipherText,
        filename: "test")); //'application/octet-stream'));
    final response = await req.send();
    /*  await http.post(Uri.parse(_messageManager.fileUploadApi),
        headers: <String, String>{
          'Content-Type': 'multipart/form-data',
        },
        body: {
          'file': encrypted.cipherText,
          'filename': 'filename',
        });*/

    //print(response.data['filename']);

    final respBody = await response.stream.bytesToString();

    return {
      'name': jsonDecode(respBody)['filename'],
      'iv': base64Encode(encrypted.nonce),
      'mac': base64Encode(encrypted.mac.bytes),
      'originFilename': result.files.single.name
    };
  }
}
