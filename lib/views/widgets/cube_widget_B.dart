// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/map_editor_controller.dart';
import 'package:remaze/models/cube.dart';
import 'package:remaze/models/game_info.dart';

import '../../services/compare_coord.dart';

class CubeBrick_B extends StatelessWidget {
  GameInfo gameInfo;
  Cube cubeProto;
  CubeBrick_B({
    Key? key,
    required this.cubeProto,
    required this.gameInfo,
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
                : (cubeProto.is_B_START || cubeProto.is_A_START)
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
    if (Compare.compareCoord(gameInfo.Player_B_Coord, cubeProto)) {
      if (Compare.compareCoord(gameInfo.Frozen_trap_A, cubeProto)) {
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
    } else if (Compare.compareCoord(gameInfo.Player_A_Coord, cubeProto)) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      if (!cubeProto.isShaddow && !Compare.compareCoord(gameInfo.Player_B_Coord, cubeProto)) {
        if (Compare.compareCoord(gameInfo.Frozen_trap_B, cubeProto) && gameInfo.Frozen_trap_B.isInit) {
          return Container(
            child: Image.asset('assets/images/snowflake.jpg'),
          );
        } else if (Compare.compareCoord(gameInfo.DoorTeleport_B, cubeProto) && gameInfo.DoorTeleport_B.isInit) {
          return Container(
            child: Opacity(
                opacity: 0.5, child: Image.asset('assets/images/teleport.jpg')),
          );
        } else if (Compare.compareCoord(gameInfo.ExitTeleport_B, cubeProto) && gameInfo.ExitTeleport_B.isInit) {
          return Container(
            child: Opacity(
                opacity: 0.9, child: Image.asset('assets/images/teleport.jpg')),
          );
        }
      }
    }
  }
}
