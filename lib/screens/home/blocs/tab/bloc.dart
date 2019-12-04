import 'dart:async';

import 'package:bloc/bloc.dart';

import 'state.dart';
import 'event.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => InitialTabState();

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    // TODO: Add Logic
  }
}
