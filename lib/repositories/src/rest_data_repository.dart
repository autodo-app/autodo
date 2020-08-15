import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

import '../../flavor.dart';
import '../../generated/pubspec.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'data_repository.dart';
import 'http_status_codes.dart';
import 'rest_write_batch.dart';
import 'write_batch_wrapper.dart';

class RestDataRepository extends DataRepository {
  RestDataRepository._(this.authRepo, this.token);

  String token;

  final AuthRepository authRepo;

  final API_BASE_URL = '${kFlavor.restApiUrl}/api/v${Pubspec.api_version}';

  static Future<RestDataRepository> open(
      {@required AuthRepository authRepo, @required String token}) async {
    return RestDataRepository._(authRepo, token);
  }

  Future<Map<String, dynamic>> _authenticatedGet(String url) async {
    var response = await get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == HTTP_401_UNAUTHORIZED) {
      // Token has expired, refresh it and try again
      token = await authRepo.refreshAccessToken();
      if (token == null) {
        throw Exception('Could not refresh access token');
      }
      response = await get(url, headers: {'Authorization': 'Bearer $token'});
    }

    if (response.statusCode != HTTP_200_OK) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> _authenticatedPost(
      String url, Map<String, dynamic> body) async {
    var response = await post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    if (response.statusCode == HTTP_401_UNAUTHORIZED) {
      // Token has expired, refresh it and try again
      token = await authRepo.refreshAccessToken();
      if (token == null) {
        throw Exception('Could not refresh access token');
      }
      response = await post(url,
          headers: {'Authorization': 'Bearer $token'}, body: body);
    }

    if (response.statusCode != HTTP_201_CREATED) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> _authenticatedPatch(
      String url, Map<String, dynamic> body) async {
    var response = await patch(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    if (response.statusCode == HTTP_401_UNAUTHORIZED) {
      // Token has expired, refresh it and try again
      token = await authRepo.refreshAccessToken();
      if (token == null) {
        throw Exception('Could not refresh access token');
      }
      response = await patch(url,
          headers: {'Authorization': 'Bearer $token'}, body: body);
    }

    if (response.statusCode != HTTP_200_OK) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> _authenticatedDelete(String url) async {
    var response =
        await delete(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == HTTP_401_UNAUTHORIZED) {
      // Token has expired, refresh it and try again
      token = await authRepo.refreshAccessToken();
      if (token == null) {
        throw Exception('Could not refresh access token');
      }
      response = await delete(url, headers: {'Authorization': 'Bearer $token'});
    }

    if (response.statusCode != HTTP_200_OK) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }

  @override
  Future<Todo> addNewTodo(Todo todo) async {
    final res =
        await _authenticatedPost('$API_BASE_URL/todos/', todo.toDocument());
    return Todo.fromMap(res['id'], res);
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final res = await _authenticatedPatch(
        '$API_BASE_URL/todos/${todo.id}/', todo.toDocument());
    return Todo.fromMap(res['id'], res);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await _authenticatedDelete('$API_BASE_URL/todos/${todo.id}/');
  }

  @override
  Future<List<Todo>> getCurrentTodos() async {
    final data = await _authenticatedGet('$API_BASE_URL/todos/');
    return data['results']
        ?.map<Todo>((t) => Todo.fromMap('${t['id']}', t))
        ?.toList();
  }

  @override
  FutureOr<WriteBatchWrapper<Todo>> startTodoWriteBatch() {
    return RestWriteBatch(
      url: '$API_BASE_URL/todos/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  @override
  Future<Refueling> addNewRefueling(Refueling refueling) async {
    final res = await _authenticatedPost(
        '$API_BASE_URL/refuelings/', refueling.toDocument());
    return Refueling.fromMap(res['id'], res);
  }

  @override
  Future<Refueling> updateRefueling(Refueling refueling) async {
    final res = await _authenticatedPatch(
        '$API_BASE_URL/refuelings/${refueling.id}/', refueling.toDocument());
    return Refueling.fromMap(res['id'], res);
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) async {
    await _authenticatedDelete('$API_BASE_URL/refuelings/${refueling.id}/');
  }

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final data = await _authenticatedGet('$API_BASE_URL/refuelings/');
    return data['results']
        ?.map<Refueling>((r) => Refueling.fromMap('${r['id']}', r))
        ?.toList();
  }

  @override
  FutureOr<WriteBatchWrapper<Refueling>> startRefuelingWriteBatch() {
    return RestWriteBatch(
      url: '$API_BASE_URL/refuelings/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  // Cars
  @override
  Future<Car> addNewCar(Car car) async {
    final res =
        await _authenticatedPost('$API_BASE_URL/cars/', car.toDocument());
    return Car.fromMap(res['id'], res);
  }

  @override
  Future<Car> updateCar(Car car) async {
    final res = await _authenticatedPatch(
        '$API_BASE_URL/cars/${car.id}/', car.toDocument());
    return Car.fromMap(res['id'], res);
  }

  @override
  Future<void> deleteCar(Car car) async {
    await _authenticatedDelete('$API_BASE_URL/cars/${car.id}/');
  }

  @override
  Future<List<Car>> getCurrentCars() async {
    final data = await _authenticatedGet('$API_BASE_URL/cars/');
    return data['results']
        ?.map<Car>((c) => Car.fromMap('${c['id']}', c))
        ?.toList();
  }

  @override
  FutureOr<WriteBatchWrapper<Car>> startCarWriteBatch() {
    return RestWriteBatch(
      url: '$API_BASE_URL/cars/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  // OdomSnapshots
  @override
  Future<OdomSnapshot> addNewOdomSnapshot(OdomSnapshot odomSnapshot) async {
    final res = await _authenticatedPost(
        '$API_BASE_URL/odomSnapshots/', odomSnapshot.toDocument());
    return OdomSnapshot.fromMap(res['id'], res);
  }

  @override
  Future<OdomSnapshot> updateOdomSnapshot(OdomSnapshot odomSnapshot) async {
    final res = await _authenticatedPatch(
        '$API_BASE_URL/odomSnapshots/${odomSnapshot.id}/',
        odomSnapshot.toDocument());
    return OdomSnapshot.fromMap(res['id'], res);
  }

  @override
  Future<void> deleteOdomSnapshot(OdomSnapshot odomSnapshot) async {
    await _authenticatedDelete(
        '$API_BASE_URL/odomSnapshots/${odomSnapshot.id}/');
  }

  @override
  Future<List<OdomSnapshot>> getCurrentOdomSnapshots() async {
    final data = await _authenticatedGet('$API_BASE_URL/odomSnapshots/');
    return data['results']
        ?.map<OdomSnapshot>((c) => OdomSnapshot.fromMap('${c['id']}', c))
        ?.toList();
  }

  @override
  FutureOr<WriteBatchWrapper<OdomSnapshot>> startOdomSnapshotWriteBatch() {
    return RestWriteBatch(
      url: '$API_BASE_URL/odomSnapshots/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  @override
  Stream<int> notificationID() {}

  @override
  Future<bool> getPaidStatus() {}

  @override
  @deprecated
  Future<List<Map<String, dynamic>>> getRepeats() {}

  @override
  List<Object> get props => [];
}
