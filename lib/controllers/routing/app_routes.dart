part of 'app_pages.dart';

abstract class Routes {
  Routes_();

  static const GENERAL_MENU = _Paths.GENERAL_MENU;
  static const GAME_ACT = _Paths.GAME_ACT;
  static const QUESTS = _Paths.QUESTS;
  static const MAP_EDITOR = _Paths.MAP_EDITOR;
  static const EDIT_MENU = _Paths.EDIT_MENU;
  static const SETTINGS = _Paths.SETTINGS;
  static const LEADERBOARD = _Paths.LEADERBOARD;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const GAME_SPLASH_SCREEN = _Paths.GAME_SPLASH_SCREEN;
  static const QR_SCANNER = _Paths.QR_SCANNER;
  static const RIVAL_SEARCH = _Paths.RIVAL_SEARCH;
  static const ACT_PLAYER_ACREEN = _Paths.ACT_PLAYER_SCREEN;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const GAME_ACT = "/game_act";
  static const QUESTS = "/quests";
  static const MAP_EDITOR = "/map_editor";
  static const EDIT_MENU = "/edit_menu";
  static const SETTINGS = "/profile_settings";
  static const LEADERBOARD = "/leaderboard";
  static const SPLASH_SCREEN = "/splash_screen";
  static const GAME_SPLASH_SCREEN = "/game_splash_screen";
  static const QR_SCANNER = "/qr_scanner";
  static const RIVAL_SEARCH = "/rival_search";
  static const ACT_PLAYER_SCREEN = "/act_player_screen";
}