import 'package:meta/meta.dart';

import '../../models/models.dart';
import 'state.dart';

class LoadingDataAction {}

class FetchDataSuccessAction {
  const FetchDataSuccessAction({@required this.data});

  final DataState data;
}

class DataFailedAction {
  const DataFailedAction({@required this.error});

  final String error;
}

class CreateTodoAction {
  const CreateTodoAction({@required this.todo});

  final Todo todo;
}

class UpdateTodoAction {
  const UpdateTodoAction({@required this.todo});

  final Todo todo;
}

class DeleteTodoAction {
  const DeleteTodoAction({@required this.todo});

  final Todo todo;
}

class CompleteTodoAction {
  const CompleteTodoAction({@required this.todo});

  final Todo todo;
}

class UnCompleteTodoAction {
  const UnCompleteTodoAction({@required this.todo});

  final Todo todo;
}

class CreateRefuelingAction {
  const CreateRefuelingAction({@required this.refueling});

  final Refueling refueling;
}

class UpdateRefuelingAction {
  const UpdateRefuelingAction({@required this.refueling});

  final Refueling refueling;
}

class DeleteRefuelingAction {
  const DeleteRefuelingAction({@required this.refueling});

  final Refueling refueling;
}

class CreateCarAction {
  const CreateCarAction({@required this.car});

  final Car car;
}

class UpdateCarAction {
  const UpdateCarAction({@required this.car});

  final Car car;
}

class DeleteCarAction {
  const DeleteCarAction({@required this.car});

  final Car car;
}
