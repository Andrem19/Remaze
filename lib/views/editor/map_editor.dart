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
      return controller.isLoading.value
          ? const CircularProgressIndicator()
          : Scaffold(
              body: Center(
                child: Container(
                  decoration: kIsWeb
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 72, 68, 68),
                          boxShadow: [
                            BoxShadow(color: Colors.green, spreadRadius: 3),
                          ],
                        )
                      : const BoxDecoration(),
                  width: kIsWeb ? Get.size.width / 3 : Get.size.width,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                              controller.mazeMap.mazeMap.length, (row) {
                            return Expanded(
                              child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                      controller.mazeMap.mazeMap[row].length,
                                      (col) {
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.changeWall(row, col);
                                        },
                                        child: CubeBrick(
                                            cubeProto: controller
                                                .mazeMap.mazeMap[row][col]),
                                      ),
                                    );
                                  })),
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Opacity(
                            opacity: 0.5,
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool isValid =
                                      await controller.checkMazeValid();
                                  print('Maze is valid: $isValid');
                                  if (isValid) {
                                    Get.defaultDialog(
                                        title: '',
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  controller.mapNameController,
                                              keyboardType: TextInputType.text,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                  labelText: 'Map Name',
                                                  hintMaxLines: 1,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green,
                                                          width: 4.0))),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.saveMap();
                                              },
                                              child: Text(
                                                'SUBMIT',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        radius: 10.0);
                                  }
                                },
                                child: const Text('Save'))),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
