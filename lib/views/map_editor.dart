import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/map_editor_controller.dart';
import 'package:remaze/views/widgets/cube_widget.dart';

class MapEditorScreen extends StatelessWidget {
  const MapEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapEditorController>(initState: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    }, dispose: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }, builder: (controller) {
      return Container(
        width: kIsWeb ? Get.size.width / 3 : Get.size.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(controller.mazeMap.mazeMap.length, (row) {
                  return Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                            controller.mazeMap.mazeMap[row].length, (col) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.changeWall(row, col);
                              },
                              child: CubeBrick(
                                  cubeProto: controller.mazeMap.mazeMap[row]
                                      [col]),
                            ),
                          );
                        })),
                  );
                }),
              ),
            ),
            Opacity(
                opacity: 0.5,
                child: ElevatedButton(onPressed: () {}, child: Text('Save')))
          ],
        ),
      );
    });
  }
}