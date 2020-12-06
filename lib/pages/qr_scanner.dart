import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const flashOn = true;
const flashOff = false;
const frontCamera = false;
const backCamera = true;

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //  Expanded(
          // flex: 10,

          // child:

          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),

          //  ),

          SafeArea(
            child:
                // Text('This is the result of scan: $qrText'),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: Icon(_isFlashOn(flashState)
                          ? Icons.flash_off
                          : Icons.flash_on),
                      onPressed: () {
                        if (controller != null) {
                          controller.toggleFlash();
                          if (_isFlashOn(flashState)) {
                            setState(() {
                              flashState = flashOff;
                            });
                          } else {
                            setState(() {
                              flashState = flashOn;
                            });
                          }
                        }
                      },
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.switch_camera),
                      onPressed: () {
                        if (controller != null) {
                          controller.flipCamera();
                          if (_isBackCamera(cameraState)) {
                            setState(() {
                              cameraState = frontCamera;
                            });
                          } else {
                            setState(() {
                              cameraState = backCamera;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 64),
              child: Container(
                constraints: BoxConstraints(minHeight: 32),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800].withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Text(
                    "Point your camera at the QR code",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFlashOn(bool current) {
    return flashOn == current;
  }

  bool _isBackCamera(bool current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (qrText == "") {
        qrText = scanData;
        print("Scanned ! : " + scanData);
        //controller.pauseCamera();
        Navigator.pop(context, scanData);
      } else {
        print("Scan mais c'est fermé ! : " + scanData);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
