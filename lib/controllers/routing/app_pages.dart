import 'package:get/get.dart';
import 'package:remaze/controllers/bindings/bindings.dart';
import 'package:remaze/views/general_menu.dart';
import 'package:remaze/views/map_editor.dart';
import 'package:remaze/views/maze_game_act.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.GENERAL_MENU;

  static final routes = [
    GetPage(
      name: _Paths.GENERAL_MENU, 
      page: () => GeneralMenu(), 
    ),
    GetPage(
      name: _Paths.GAME_ACT, 
      page: () => MazeGameAct(),
      binding: GameActBinding()
    ),
    GetPage(
      name: _Paths.MAP_EDITOR, 
      page: () => MapEditorScreen(),
      binding: MapEditorBinding()
    ),
    // GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    // GetPage(name: _Paths.SIGNUP, page: () => Container()),
  ];
}