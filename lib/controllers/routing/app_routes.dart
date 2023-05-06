part of 'app_pages.dart';

abstract class Routes {
  Routes_();

  static const GENERAL_MENU = _Paths.GENERAL_MENU;
  static const GAME_ACT = _Paths.GAME_ACT;
  static const QUESTS = _Paths.QUESTS;
  static const MAP_EDITOR = _Paths.MAP_EDITOR;
  static const EDIT_MENU = _Paths.EDIT_MENU;
  static const START_MENU = _Paths.START_MENU;
  static const SETTINGS = _Paths.SETTINGS;
  static const LEADERBOARD = _Paths.LEADERBOARD;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const GAME_ACT = "/game_act";
  static const QUESTS = "/quests";
  static const MAP_EDITOR = "/map_editor";
  static const EDIT_MENU = "/edit_menu";
  static const START_MENU = "/start_menu";
  static const SETTINGS = "/profile_settings";
  static const LEADERBOARD = "/leaderboard";
}