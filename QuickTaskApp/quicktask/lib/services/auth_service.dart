import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuthService {
  Future<ParseUser?> signUp(String username, String email, String password) async {
    var user = ParseUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      return user;
    } else {
      return null;
    }
  }

  Future<ParseUser?> login(String username, String password) async {
    var user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      return user;
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    var user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }

  Future<ParseUser?> getCurrentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }
}