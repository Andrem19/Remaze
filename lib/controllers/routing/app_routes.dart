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
  static const FINISH_PAGE = _Paths.FINISH_PAGE;
  static const GENERAL_LEADERBOARD = _Paths.GENERAL_LEADERBOARD;
  static const INVITE_BATTLE = _Paths.INVITE_BATTLE;
  static const FIGHT_BATTLE_ACT = _Paths.FIGHT_BATTLE_ACT;
  static const END_GAME_SCREEN = _Paths.END_GAME_SCREEN;
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
  static const FINISH_PAGE = "/finish_page";
  static const GENERAL_LEADERBOARD = "/general_leaderboard";
  static const INVITE_BATTLE = "/invite_battle";
  static const FIGHT_BATTLE_ACT = "/fight_battle_act";
  static const END_GAME_SCREEN = "/end_game_screen";
}