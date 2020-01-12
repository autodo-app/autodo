import 'package:equatable/equatable.dart';

abstract class WriteBatchWrapper extends Equatable {
  void updateData(String id, dynamic data);

  void setData(dynamic data);

  Future<void> commit();
}
