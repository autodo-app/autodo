import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/screens/home/views/repeats.dart';

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

void main() {
  RepeatsBloc repeatsBloc;

  setUp(() {
    repeatsBloc = MockRepeatsBloc();
  });

  group('RepeatsScreen', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(repeatsBloc.state).thenReturn(RepeatsLoading());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<RepeatsBloc>.value(
              value: repeatsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: RepeatsScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
    testWidgets('loaded', (WidgetTester tester) async {
      when(repeatsBloc.state).thenReturn(
          RepeatsLoaded([Repeat(name: 'test', mileageInterval: 0, cars: ['test'])]));
      Key repeatsKey = Key('repeats');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<RepeatsBloc>.value(
              value: repeatsBloc,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: RepeatsScreen(key: repeatsKey),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byKey(repeatsKey), findsOneWidget);
    });
  });
}
