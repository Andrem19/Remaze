import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../controllers/qr_controller.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  QrController qrCtrl = Get.find<QrController>();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrCtrl.controller!.pauseCamera();
    }
    qrCtrl.controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(flex: 4, child: controller.BuildQrView(context)),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (controller.result != null)
                        Text(
                            'Barcode Type: ${describeEnum(controller.result!.format)}   Data: ${controller.result!.code}')
                      else
                        const Text('Scan a code'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller.controller?.pauseCamera();
                              },
                              child: const Text('pause',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller.controller?.resumeCamera();
                              },
                              child: const Text('resume',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  
}
