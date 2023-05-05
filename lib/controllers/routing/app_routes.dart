part of 'app_pages.dart';

abstract class Routes {
  Routes_();

  static const GENERAL_MENU = _Paths.GENERAL_MENU;
  static const GAME_ACT = _Paths.GAME_ACT;
  static const MAP_EDITOR = _Paths.MAP_EDITOR;
  static const EDIT_MENU = _Paths.EDIT_MENU;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const GAME_ACT = "/game_act";
  static const MAP_EDITOR = "/map_editor";
  static const EDIT_MENU = "/edit_menu";
  static const SETTINGS = "/profile_settings";
}