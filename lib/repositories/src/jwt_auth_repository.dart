import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../flavor.dart';
import 'auth_repository.dart';

class JwtAuthRepository implements AuthRepository {

  /// Creates a new user using email, password, and the email in the username
  /// field. Once the account is registered then a JWT is fetched for future
  /// authentication.
  @override
  Future<void> signUp(String email, String password, {bool verify}) async {
    final res = await post('${kFlavor.restApiUrl}/accounts/register/', body: {
      'username': email,
      'password': password,
      'password_confirm': password,
      'email': email
    });
    if (res.statusCode != 201) {
      throw Exception(
          'Could not register user. Error Code: ${res.statusCode}, response: ${res.body}');
    }
    await FlutterSecureStorage().write(key: 'email', value: email);
    await logIn(email, password);
  }

  @override
  Future<void> logIn(String email, String password) async {
    final res = await post('${kFlavor.restApiUrl}/auth/token/',
        body: {'username': email, 'password': password});
    if (res.statusCode != 200) {
      throw Exception('Could not authenticate user');
    }
    final jwt = json.decode(res.body);
    await FlutterSecureStorage().write(key: 'jwt_access', value: jwt['access']);
    await FlutterSecureStorage()
        .write(key: 'jwt_refresh', value: jwt['refresh']);
  }

  /// Checks to see if there is a valid access token saved currently. If the
  /// token has expired then a new token will be generated from the refresh
  /// token.
  @override
  Future<bool> isLoggedIn() async {
    final jwt = await FlutterSecureStorage().read(key: 'jwt_access');
    if (jwt == null) {
      return false;
    }

    final jwtFields = jwt.split('.');
    if (jwtFields.length != 3) {
      print('Invalid JWT read from storage');
      return false;
    }
    final payload = json
        .decode(ascii.decode(base64.decode(base64.normalize(jwtFields[1]))));
    if (DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000)
        .isAfter(DateTime.now())) {
      return false;
      // return true; // current access is good, no need to refresh
    }

    // Use the refresh key to get a new access key
    final newToken = refreshAccessToken();
    return newToken != null;
  }

  @override
  Future<void> logOut() async {}

  @override
  Future<void> deleteCurrentUser() async {}

  @override
  Future<String> getCurrentUserEmail() async {
    return FlutterSecureStorage().read(key: 'email');
  }

  @override
  Future<String> getCurrentUserToken() async {
    return FlutterSecureStorage().read(key: 'jwt_access');
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<String> refreshAccessToken() async {
    final refresh = await FlutterSecureStorage().read(key: 'jwt_refresh');
    final res = await post('${kFlavor.restApiUrl}/auth/token/refresh/',
        body: {'refresh': refresh});
    if (res.statusCode != 200) {
      throw Exception('Failed to refresh access token');
    }
    final newAccessToken = json.decode(res.body)['access'];
    await FlutterSecureStorage()
        .write(key: 'jwt_access', value: newAccessToken);
    return newAccessToken;
  }
}
