import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'http_status_codes.dart';
import 'write_batch_wrapper.dart';

class RestWriteBatch<T extends WriteBatchDocument> extends Equatable
    implements WriteBatchWrapper<T> {
  RestWriteBatch({@required this.url, @required this.getToken});

  final String url;

  final Future<String> Function() getToken;

  final Map<String, Map<String, String>> updates = {};

  final List<Map<String, String>> puts = [];

  @override
  void updateData(String id, T data) => updates[id] = data.toDocument();

  @override
  void setData(T data) => puts.add(data.toDocument());

  @override
  Future<void> commit() async {
    for (var put in puts) {
      var token = await getToken();
      var res = await post(url,
          headers: {'Authorization': 'Bearer $token'}, body: put);
      if (res.statusCode == HTTP_401_UNAUTHORIZED) {
        // Token expired, try again
        token = await getToken();
        res = await post(url,
          headers: {'Authorization': 'Bearer $token'}, body: put);
      }
      if (res.statusCode != HTTP_201_CREATED) {
        print('here');
        break;
      }
      print(res.body);
    }
    for (var update in updates.entries) {
      final token = await getToken();
      final res = await patch('$url${update.key}/',
          headers: {'Authorization': 'Bearer $token'}, body: update.value);
      if (res.statusCode != HTTP_200_OK) {
        print('here');
        break;
      }
    }
  }

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RestWriteBatch';
}
