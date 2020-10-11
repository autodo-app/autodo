import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/models.dart';
import 'http_status_codes.dart';

/// Wrapper around the REST operations used with the auToDo API.
class AutodoApi extends Equatable {
  const AutodoApi(
      {this.version = 'v1', this.baseUrl = 'http://localhost:8000'});

  /// The version string used when accessing the API.
  final String version;

  /// The URL root for the API.
  final String baseUrl;

  /// Checks the metadata in a JWT to determine if the token is still valid.
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

  /// Requests a new access token from the API using the refresh token.
  Future<String> _refreshAccessToken() async {
    final curTokenIsGood = await _accessTokenStillValid();
    if (curTokenIsGood) {
      return FlutterSecureStorage().read(key: 'access');
    }
    final refresh = await FlutterSecureStorage().read(key: 'refresh');
    final res =
        await post('$baseUrl/auth/token/refresh/', body: {'refresh': refresh});
    if (res.statusCode != HTTP_200_OK) {
      throw Exception('Failed to refresh access token');
    }
    final newAccessToken = json.decode(res.body)['access'];
    await FlutterSecureStorage().write(key: 'access', value: newAccessToken);
    return newAccessToken;
  }

  // /// Sends a GET request to the API using the user's access JWT. Refreshes the
  // /// token and retries the request with a new access JWT if needed.
  // Future<Map<String, dynamic>> _authenticatedGet(String url) async {
  //   final token = FlutterSecureStorage().read(key: 'access');
  //   var response = await get(url, headers: {'Authorization': 'Bearer $token'});
  //   if (response.statusCode == HTTP_401_UNAUTHORIZED) {
  //     // Token has expired, refresh it and try again
  //     final newToken = await _refreshAccessToken();
  //     if (newToken == null) {
  //       throw Exception('Could not refresh access token');
  //     }
  //     await FlutterSecureStorage().write(key: 'access', value: newToken);
  //     response = await get(url, headers: {'Authorization': 'Bearer $newToken'});
  //   }

  //   if (response.statusCode != HTTP_200_OK) {
  //     throw Exception('Failed to access API');
  //   }
  //   final data = await json.decode(response.body);
  //   return data;
  // }

  // /// Sends a POST request to the API using the user's access JWT. Refreshes the
  // /// token and retries the request with a new access JWT if needed.
  // Future<Map<String, dynamic>> _authenticatedPost(
  //     String url, Map<String, dynamic> body) async {
  //   final token = FlutterSecureStorage().read(key: 'access');
  //   var response = await post(url,
  //       headers: {'Authorization': 'Bearer $token'}, body: body);
  //   if (response.statusCode == HTTP_401_UNAUTHORIZED) {
  //     // Token has expired, refresh it and try again
  //     final newToken = await _refreshAccessToken();
  //     if (newToken == null) {
  //       throw Exception('Could not refresh access token');
  //     }
  //     await FlutterSecureStorage().write(key: 'access', value: newToken);
  //     response = await post(url,
  //         headers: {'Authorization': 'Bearer $newToken'}, body: body);
  //   }

  //   if (response.statusCode != HTTP_201_CREATED) {
  //     throw Exception('Failed to access API');
  //   }
  //   final data = await json.decode(response.body);
  //   return data;
  // }

  // /// Sends a PATCH request to the API using the user's access JWT. Refreshes
  // /// the token and retries the request with a new access JWT if needed.
  // Future<Map<String, dynamic>> _authenticatedPatch(
  //     String url, Map<String, dynamic> body) async {
  //   final token = await FlutterSecureStorage().read(key: 'access');
  //   var response = await patch(url,
  //       headers: {'Authorization': 'Bearer $token'}, body: body);
  //   if (response.statusCode == HTTP_401_UNAUTHORIZED) {
  //     // Token has expired, refresh it and try again
  //     final newToken = await _refreshAccessToken();
  //     if (newToken == null) {
  //       throw Exception('Could not refresh access token');
  //     }
  //     await FlutterSecureStorage().write(key: 'access', value: newToken);
  //     response = await patch(url,
  //         headers: {'Authorization': 'Bearer $newToken'}, body: body);
  //   }

  //   if (response.statusCode != HTTP_200_OK) {
  //     throw Exception('Failed to access API');
  //   }
  //   final data = await json.decode(response.body);
  //   return data;
  // }

  /// Sends a DELETE request to the API using the user's access JWT. Refreshes
  /// the token and retries the request with a new access JWT if needed.
  Future<Map<String, dynamic>> _authenticatedDelete(String url) async {
    final token = await FlutterSecureStorage().read(key: 'access');
    var response =
        await delete(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == HTTP_401_UNAUTHORIZED) {
      // Token has expired, refresh it and try again
      final newToken = await _refreshAccessToken();
      if (newToken == null) {
        throw Exception('Could not refresh access token');
      }
      await FlutterSecureStorage().write(key: 'access', value: newToken);
      response =
          await delete(url, headers: {'Authorization': 'Bearer $newToken'});
    }

    if (response.statusCode != HTTP_200_OK) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }

  /// Creates a new user object on the server. This does not log in the user
  /// automatically, [fetchUserToken] should be invoked after the user is
  /// created to get the API access tokens.
  Future<void> registerUser(String username, String password) async {
    final res = await post('$baseUrl/accounts/register', body: {
      'username': username,
      'password': password,
      'password_confirm': password,
      'email': username
    });
    if (res.statusCode != 201) {
      throw Exception(
          'Could not register user. Error Code: ${res.statusCode}, response: ${res.body}');
    }
  }

  /// Retrieves the access and refresh tokens for future access to the API.
  Future<TokenPair> fetchUserToken(String username, String password) async {
    final res = await post('$baseUrl/auth/token/',
        body: {'username': username, 'password': password});
    if (res.statusCode != HTTP_200_OK) {
      throw Exception('Could not authenticate user');
    }
    final jwt = json.decode(res.body);
    return TokenPair(access: jwt['access'], refresh: jwt['refresh']);
  }

  /// Deletes the locally stored data associated with the logged in user.
  Future<void> logOut() async {
    await FlutterSecureStorage().delete(key: 'access');
    await FlutterSecureStorage().delete(key: 'refresh');
  }

  /// Deletes all data associated with the user on the server and then logs out.
  Future<void> deleteCurrentUser() async {
    await _authenticatedDelete('$baseUrl/accounts/profile/');
    await logOut();
  }

  /// Returns the URL where the image is stored for the car specified by [id].
  String imageDownloadUrl(String id, String imageName) =>
      '$baseUrl/cars/$id/$imageName';

  @override
  List<Object> get props => [version, baseUrl];
}
