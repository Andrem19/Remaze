import 'package:get/get.dart';
import 'package:remaze/controllers/bindings/bindings.dart';
import 'package:remaze/views/editor/edit_menu.dart';
import 'package:remaze/views/game/quests.dart';
import 'package:remaze/views/general_menu.dart';
import 'package:remaze/views/editor/map_editor.dart';
import 'package:remaze/views/game/maze_game_act.dart';
import 'package:remaze/views/leaderboard_screen.dart';
import 'package:remaze/views/profile_settings.dart';

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
    GetPage(
      name: _Paths.SETTINGS, 
      page: () => ProfileSettings(),
    ),
    GetPage(
      name: _Paths.EDIT_MENU, 
      page: () => EditMenu(),
      binding: MapEditorBinding()
    ),
    GetPage(
      name: _Paths.QUESTS, 
      page: () => QuestsScreen(),
      binding: GameMenuBinding()
    ),
    GetPage(
      name: _Paths.LEADERBOARD, 
      page: () => LeaderBoardScreen(),
      binding: GameMenuBinding()
    ),
  ];
}