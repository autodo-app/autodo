import 'package:equatable/equatable.dart';

abstract class WriteBatchDocument {
  Map<String, String> toDocument();
}

enum WRITE_OPERATION { POST, PATCH }

abstract class WriteBatchWrapper<T extends WriteBatchDocument>
    extends Equatable {
  void updateData(String id, T data);

  void setData(T data);

  Future<Map<WRITE_OPERATION, dynamic>> commit();
}
