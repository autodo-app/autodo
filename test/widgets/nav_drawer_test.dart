import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/blocs/blocs.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('nav drawer', () {
    testWidgets('render', (tester) async {
      final authBloc = MockAuthenticationBloc();
      when(authBloc.state).thenReturn(Authenticated('test', 'test', false));
      whenListen(authBloc,
          Stream.fromIterable([Authenticated('test', 'test', false)]));
      await tester.pumpWidget(BlocProvider<AuthenticationBloc>(
          create: (context) => authBloc,
          child: MaterialApp(
              home: Scaffold(
                  appBar: AppBar(), drawer: NavDrawer(), body: Container()))));
      await tester.tap(find.byTooltip("Open navigation menu"));
      await tester.pumpAndSettle();
      expect(find.byType(NavDrawer), findsOneWidget);
    });
  });
}
