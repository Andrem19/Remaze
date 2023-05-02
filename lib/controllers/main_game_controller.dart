import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainGameController extends GetxController {
  late SharedPreferences pref;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  void getUserDetails() {

  }

}