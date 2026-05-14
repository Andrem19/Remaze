import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogClass {
  static Future<bool> pushDialog(String whoAskMe) async {
    var completer = Completer<bool>();
    await Get.defaultDialog(
        title: '$whoAskMe invite you to game. Do you want to play?',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    completer.complete(false);
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    completer.complete(true);
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            )
          ],
        ),
        radius: 10.0);
        return completer.future;
  }
}
