part of 'app_pages.dart';


abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const onboarding = _Paths.onboarding;
  static const login = _Paths.login;
  static const signup = _Paths.signup;
  static const verification = _Paths.verification;
  static const confirmation = _Paths.confirmation;
  static const forgotPassword = _Paths.forgotPassword;
  static const newPassword = _Paths.newPassword;
  static const splash = _Paths.splash;
  static const subscription = _Paths.subscription;
  static const history = _Paths.history;
  static const historyDetail = _Paths.historyDetail;
}

abstract class _Paths {
  _Paths._();
  static const home = '/home';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const verification = '/verification';
  static const confirmation = '/confirmation';
  static const forgotPassword = '/forgot-password';
  static const newPassword = '/new-password';
  static const splash = '/splash';
  static const subscription = '/subscription';
  static const history = '/history';
  static const historyDetail = '/history-detail';
}
