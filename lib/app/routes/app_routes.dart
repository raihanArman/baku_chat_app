part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const INTRO = _Paths.INTRODUCTION;
  static const PROFILE = _Paths.PROFILE;
  static const CHAT_ROOM = _Paths.CHAT_ROOM;
  static const SEARCH = _Paths.SEARCH;
  static const UPDATE_STATUS = _Paths.UPDATE_STATUS;
  static const CHANGE_PROFILE = _Paths.CHANGE_PROFILE;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const INTRODUCTION = '/intro';
  static const PROFILE = '/profile';
  static const CHAT_ROOM = '/chat_room';
  static const SEARCH = '/search';
  static const UPDATE_STATUS = '/update-status';
  static const CHANGE_PROFILE = '/change-profile';
}
