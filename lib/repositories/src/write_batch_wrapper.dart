import 'package:equatable/equatable.dart';

abstract class WriteBatchDocument {
  Map<String, Object> toDocument();
}

abstract class WriteBatchWrapper<T extends WriteBatchDocument>
    extends Equatable {
  void updateData(String id, T data);

  void setData(T data);

  Future<void> commit();
}
