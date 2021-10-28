part of 'app_pages.dart';


abstract class Routes {
  Routes._();

  static const login = _Paths.login;

  static String loginThen(String afterSuccessFullLogin) =>
      '$login?then=${Uri.encodeQueryComponent(afterSuccessFullLogin)}';
  static const home = _Paths.home;
  static const incides = home + _Paths.incides;

  static String incidesDetails(String idIncide) => '$incides/$idIncide';
  static const dashboard = _Paths.dashboard;
  static const users = dashboard + _Paths.users;
  static String adminThen(String afterSuccessFullLogin) =>
      '$home?then=${Uri.encodeQueryComponent(afterSuccessFullLogin)}';
}

abstract class _Paths {
  static const login = '/login';
  static const home = '/home';
  static const incides = '/incides';
  static const incidesDetails = '/:idIncide';
  static const dashboard = '/dashboard';
  static const users = '/users';
}
