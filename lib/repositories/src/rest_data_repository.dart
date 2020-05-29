import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

import '../../flavor.dart';
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
  Future<void> addNewTodo(Todo todo) async {
    await _authenticatedPost(
        '${kFlavor.restApiUrl}/todos/', todo.toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await _authenticatedDelete('${kFlavor.restApiUrl}/todos/${todo.id}/');
  }

  @override
  Future<List<Todo>> getCurrentTodos() async {
    final data = await _authenticatedGet('${kFlavor.restApiUrl}/todos/');
    return data['results']
        ?.map<Todo>((t) => Todo.fromMap('${t['id']}', t))
        ?.toList();
  }

  @override
  Future<Map<String, dynamic>> updateTodo(Todo todo) async {
    return _authenticatedPatch(
        '${kFlavor.restApiUrl}/todos/${todo.id}/', todo.toDocument());
  }

  @override
  Stream<List<Todo>> todos() {}

  @override
  FutureOr<WriteBatchWrapper<Todo>> startTodoWriteBatch() {
    return RestWriteBatch(
      url: '${kFlavor.restApiUrl}/todos/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) async {
    await _authenticatedPost(
        '${kFlavor.restApiUrl}/refuelings/',
        refueling.toDocument());
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) async {
    await _authenticatedDelete(
        '${kFlavor.restApiUrl}/refuelings/${refueling.id}/');
  }

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final data = await _authenticatedGet('${kFlavor.restApiUrl}/refuelings/');
    return data['results']
        ?.map<Refueling>((r) => Refueling.fromMap('${r['id']}', r))
        ?.toList();
  }

  @override
  Future<Map<String, dynamic>> updateRefueling(Refueling refueling) async {
    return _authenticatedPatch(
        '${kFlavor.restApiUrl}/refuelings/${refueling.id}/',
        refueling.toDocument());
  }

  @override
  Stream<List<Refueling>> refuelings([bool _]) {}

  @override
  FutureOr<WriteBatchWrapper<Refueling>> startRefuelingWriteBatch() {
    return RestWriteBatch(
      url: '${kFlavor.restApiUrl}/refuelings/',
      getToken: authRepo.refreshAccessToken,
    );
  }

  // Cars
  @override
  Future<void> addNewCar(Car car) async {
    await _authenticatedPost(
        '${kFlavor.restApiUrl}/cars/', car.toDocument());
  }

  @override
  Future<void> deleteCar(Car car) async {
    await _authenticatedDelete('${kFlavor.restApiUrl}/cars/${car.id}/');
  }

  @override
  Stream<List<Car>> cars() {}

  @override
  Future<List<Car>> getCurrentCars() async {
    final data = await _authenticatedGet('${kFlavor.restApiUrl}/cars/');
    return data['results']
        ?.map<Car>((c) => Car.fromMap('${c['id']}', c))
        ?.toList();
  }

  @override
  Future<Map<String, dynamic>> updateCar(Car car) async {
    return _authenticatedPatch(
        '${kFlavor.restApiUrl}/cars/${car.id}/', car.toDocument());
  }

  @override
  FutureOr<WriteBatchWrapper<Car>> startCarWriteBatch() {
    return RestWriteBatch(
      url: '${kFlavor.restApiUrl}/cars/',
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
