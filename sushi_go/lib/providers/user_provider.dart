class UserProvider {
  static final UserProvider _instance = UserProvider._internal();
  String username = 'Sebas';

  UserProvider._internal();
  factory UserProvider() {
    return _instance;
  }
}
