import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../flavor.dart';
import 'auth_repository.dart';
import 'http_status_codes.dart';

class JwtAuthRepository implements AuthRepository {
  Future<bool> _accessTokenStillValid() async {
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
        .subtract(Duration(seconds: 30))
        .isAfter(DateTime.now())) {
      // Subtract a bit of time to ensure that the token will be good for long
      // enough to get some API requests in. If the token still has a while left
      // then keep it.
      return true;
    }
    return false;
  }

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
    if (res.statusCode != HTTP_200_OK) {
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
    final curTokenIsGood = await _accessTokenStillValid();
    if (curTokenIsGood) {
      return true;
    }

    try {
      // Use the refresh key to get a new access key
      await refreshAccessToken();
      return true;
    } catch (e) {
      // If we can't get a new access token then there either isn't a user
      // or we're having issues authenticating them for some reason
      // TODO: use some sort of local cache in the case of no internet access
      // or just return a specialized error message?
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    await FlutterSecureStorage().delete(key: 'jwt_access');
    await FlutterSecureStorage().delete(key: 'jwt_refresh');
    await FlutterSecureStorage().delete(key: 'email');
  }

  @override
  Future<void> deleteCurrentUser() async {
    final res =
        await delete('${kFlavor.restApiUrl}/accounts/profile/', headers: {
      'Authorization': await FlutterSecureStorage().read(key: 'jwt_access'),
    });
    if (res.statusCode == HTTP_401_UNAUTHORIZED) {
      // Get a new token and retry
      await refreshAccessToken();
      await delete('${kFlavor.restApiUrl}/accounts/profile/', headers: {
        'Authorization': await FlutterSecureStorage().read(key: 'jwt_access'),
      });
    }
    await logOut();
  }

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
    final curTokenIsGood = await _accessTokenStillValid();
    if (curTokenIsGood) {
      return FlutterSecureStorage().read(key: 'jwt_access');
    }
    final refresh = await FlutterSecureStorage().read(key: 'jwt_refresh');
    final res = await post('${kFlavor.restApiUrl}/auth/token/refresh/',
        body: {'refresh': refresh});
    if (res.statusCode != HTTP_200_OK) {
      throw Exception('Failed to refresh access token');
    }
    final newAccessToken = json.decode(res.body)['access'];
    await FlutterSecureStorage()
        .write(key: 'jwt_access', value: newAccessToken);
    return newAccessToken;
  }
}
