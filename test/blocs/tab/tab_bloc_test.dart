import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';

void main() {
  blocTest('UpdateTab', 
    build: () {
      return TabBloc();
    },
    act: (bloc) async => bloc.add(UpdateTab(AppTab.refuelings)),
    expect: [
      AppTab.todos,
      AppTab.refuelings
    ]
  );
}