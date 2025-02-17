final class Routes {
  static final Routes _instance = Routes._();

  const Routes._();

  factory Routes() => _instance;

  String get home => '/home';
  String get profile => '/profile';
}
