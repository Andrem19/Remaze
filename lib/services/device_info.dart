// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:platform_device_id/platform_device_id.dart';

// class DeviceInfo {
//   static Future<String> getDeviceId() async {
//     String? deviceId;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       deviceId = await PlatformDeviceId.getDeviceId;
//     } on PlatformException {
//       deviceId = 'Failed to get deviceId.';
//     }
//     return deviceId.toString();
//   }

//   static Future printIps() async {
//     for (var interface in await NetworkInterface.list()) {
//       print('== Interface: ${interface.name} ==');
//       for (var addr in interface.addresses) {
//         print(
//             '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
//       }
//     }
//   }
// }
