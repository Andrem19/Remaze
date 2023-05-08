// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/map_editor_controller.dart';
import 'package:remaze/models/cube.dart';

class CubeBrick extends StatelessWidget {
  Cube cubeProto;
  CubeBrick({
    Key? key,
    required this.cubeProto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cubeProto.isShaddow) {
      return Container(
        color: Colors.black38,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: cubeProto.wall
              ? Color.fromARGB(255, 43, 26, 23)
              : (cubeProto.is_A_START || cubeProto.is_B_START)
                  ? Colors.yellow
                  : Colors.white30,
          border: Border.all(
            width: 2.0,
            color: Colors.black12,
          ),
        ),
        child: createStuff(cubeProto));
    }
    
  }

  Container? createStuff(Cube cubeProto) {
    if (cubeProto.isPlayer_A_Here) {
      if (cubeProto.isFrozen_B_Here) {
        return Container(
        child: Image.asset('assets/images/snowflake.jpg'),
      );
      }
      return Container(
        decoration: new BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      );
    } else if (cubeProto.isPlayer_B_Here) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return null;
    }
  }
}
