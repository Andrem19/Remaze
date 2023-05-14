import 'package:get/get.dart';
import 'package:remaze/controllers/bindings/bindings.dart';
import 'package:remaze/views/editor/edit_menu.dart';
import 'package:remaze/views/game/multiplayer_game_act.dart';
import 'package:remaze/views/game/quests.dart';
import 'package:remaze/views/game_splash_screen.dart';
import 'package:remaze/views/general_menu.dart';
import 'package:remaze/views/editor/map_editor.dart';
import 'package:remaze/views/game/maze_game_act.dart';
import 'package:remaze/views/leaderboard_screen.dart';
import 'package:remaze/views/profile_settings.dart';
import 'package:remaze/views/widgets/act_player_screen.dart';
import 'package:remaze/views/widgets/qr_scanner.dart';

import '../../splash_screen.dart';
import '../../views/game/search_rival.dart';

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
    GetPage(
      name: _Paths.SPLASH_SCREEN, 
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.GAME_SPLASH_SCREEN, 
      page: () => GameSplashScreen(),
    ),
    GetPage(
      name: _Paths.QR_SCANNER, 
      page: () => QRViewExample(),
      binding: QrControllerBinding()
    ),
    GetPage(
      name: _Paths.RIVAL_SEARCH, 
      page: () => WaitingScreen(),
      binding: SearchRivalBinding()
    ),
    GetPage(
      name: _Paths.ACT_PLAYER_SCREEN, 
      page: () => MultiplayerGameAct(),
      binding: FightControllerBinding()
    ),
  ];
}