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

  final Map<String, Map<String, String>> patches = {};

  final List<Map<String, String>> posts = [];

  @override
  void updateData(String id, T data) => patches[id] = data.toDocument();

  @override
  void setData(T data) => posts.add(data.toDocument());

  /// Applies the requested operations and returns the results in JSON format.
  ///
  /// It is up to the caller to map the response to a model if desired.
  @override
  Future<Map<WRITE_OPERATION, dynamic>> commit() async {
    final out = <WRITE_OPERATION, dynamic>{
      WRITE_OPERATION.POST: [],
      WRITE_OPERATION.PATCH: [],
    };
    for (var obj in posts) {
      var token = await getToken();
      var res = await post(url,
          headers: {'Authorization': 'Bearer $token'}, body: obj);
      if (res.statusCode == HTTP_401_UNAUTHORIZED) {
        // Token expired, try again
        token = await getToken();
        res = await post(url,
            headers: {'Authorization': 'Bearer $token'}, body: obj);
      }
      if (res.statusCode != HTTP_201_CREATED) {
        print('here');
        break;
      }
      out[WRITE_OPERATION.POST].add(res.body);
      print(res.body);
    }
    for (var update in patches.entries) {
      final token = await getToken();
      final res = await patch('$url${update.key}/',
          headers: {'Authorization': 'Bearer $token'}, body: update.value);
      if (res.statusCode != HTTP_200_OK) {
        print('here');
        break;
      }
      out[WRITE_OPERATION.PATCH].add(res.body);
    }
    return out;
  }

  @override
  List<Object> get props => [url, getToken, posts, patches];

  @override
  String toString() => 'RestWriteBatch';
}
