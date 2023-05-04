import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/views/widgets/custom_text_field.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: GetBuilder<MainGameController>(builder: (controller) {
            return Scaffold(
                appBar: AppBar(
                  title: Center(child: const Text('SETTINGS')),
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'User Name:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: kIsWeb
                                ? Get.size.width / 6
                                : Get.size.width / 2,
                            child: CustomTextField(
                                controller: controller.userNameController.value,
                                iconData: Icons.person,
                                hintText: 'User Name'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                              onPressed: () {
                                controller.updateName();
                              },
                              child: Text('Submit')),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Migration Token:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${controller.migrationTokenGen}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          onPressed: () {
                            controller.generateMigrationToken();
                          },
                          child: Text('Generate And Copy')),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Input the token from the account you want to transfer to this device:',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        width: kIsWeb ? Get.size.width / 6 : Get.size.width / 2,
                        child: CustomTextField(
                            controller: controller.migrationToken.value,
                            iconData: Icons.swap_horiz,
                            hintText: 'Token'),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          onPressed: () {
                            controller.migrate();
                          },
                          child: const Text('Migrate')),
                      // StreamBuilder(
                      //   stream: controller.documentStream,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasError) {
                      //       return Text('Something went wrong');
                      //     }
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Text("Loading");
                      //     }

                      //     return Text(snapshot.data['user']);
                      //   },
                      // )
                    ],
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
