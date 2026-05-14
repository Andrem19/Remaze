import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/views/widgets/battle_screen.dart';

class BattleAct extends StatelessWidget {
  const BattleAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: kIsWeb ? BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 72, 68, 68),
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 3),
            ],
          ) : const BoxDecoration(),
          width: kIsWeb ? Get.size.width / 3 : Get.size.width,
          child: BattleScreen(),
        ),
      ),
    );
  }
}