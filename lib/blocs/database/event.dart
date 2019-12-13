import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class LoadDatabase extends DatabaseEvent {}

class UserLoggedIn extends DatabaseEvent {
  final String uuid;

  const UserLoggedIn(this.uuid);

  @override 
  List<Object> get props => [uuid];
}

class UserLoggedOut extends DatabaseEvent {}