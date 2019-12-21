import 'dart:async';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'package:autodo/models/barrel.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.todos;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}