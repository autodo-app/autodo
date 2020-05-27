import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'data_repository.dart';
import 'write_batch_wrapper.dart';

class RestDataRepository extends DataRepository {
  RestDataRepository._(this.authRepo, this.token);

  String token;

  final AuthRepository authRepo;

  static const API_BASE_URL = 'http://ed9aa195.ngrok.io';

  static Future<RestDataRepository> open({@required AuthRepository authRepo, @required String token}) async {
    return RestDataRepository._(authRepo, token);
  }

  Future<Map<String, dynamic>> _authenticatedGet(String url) async {
    var response = await get(
      url,
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode == 401) {
      // Token has expired, refresh it and try again
      token = await authRepo.refreshAccessToken();
      if (token == null) {
        throw Exception('Could not refresh access token');
      }
      response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        }
      );
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to access API');
    }
    final data = await json.decode(response.body);
    return data;
  }
  
  @override
  Future<void> addNewTodo(Todo todo) async {
    final response = await post(
      'https://jsonplaceholder.typicode.com/albums',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: await FlutterSecureStorage().read(key: 'jwt'),
      },
      body: jsonEncode(todo.toDocument()),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // return Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) {}

  @override
  Stream<List<Todo>> todos() {}

  @override
  Future<List<Todo>> getCurrentTodos() async {
    final data = await _authenticatedGet('$API_BASE_URL/todos/');
    return data['results']?.map<Todo>((t) => Todo.fromMap('${t['id']}', t))?.toList();
  }

  @override
  Future<void> updateTodo(Todo todo) {}

  @override
  FutureOr<WriteBatchWrapper<Todo>> startTodoWriteBatch() {}

  @override
  Future<void> addNewRefueling(Refueling refueling) {}

  @override
  Future<void> deleteRefueling(Refueling refueling) {}

  @override
  Stream<List<Refueling>> refuelings([bool forceRefresh]) {}

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final data = await _authenticatedGet('$API_BASE_URL/refuelings/');
    return data['results']?.map<Refueling>((r) => Refueling.fromMap('${r['id']}', r))?.toList();
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {}

  @override
  FutureOr<WriteBatchWrapper<Refueling>> startRefuelingWriteBatch() {}

  // Cars
  @override
  Future<void> addNewCar(Car car) {}

  @override
  Future<void> deleteCar(Car car) {}

  @override
  Stream<List<Car>> cars() {}

  @override
  Future<List<Car>> getCurrentCars() async {
    final data = await _authenticatedGet('$API_BASE_URL/cars/');
    return data['results']?.map<Car>((c) => Car.fromMap('${c['id']}', c))?.toList();
  }

  @override
  Future<void> updateCar(Car car) {}

  @override
  FutureOr<WriteBatchWrapper<Car>> startCarWriteBatch() {}

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