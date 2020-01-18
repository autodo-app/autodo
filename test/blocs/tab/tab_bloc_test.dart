import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';

void main() {
  blocTest('UpdateTab',
      build: () {
        return TabBloc();
      },
      act: (bloc) async => bloc.add(UpdateTab(AppTab.refuelings)),
      expect: [AppTab.todos, AppTab.refuelings]);
}
