import 'package:autodo/units/distance.dart';
import 'package:autodo/units/volume.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/screens/home/views/repeats.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockRepeatsBloc extends MockBloc<RepeatsEvent, RepeatsState>
    implements RepeatsBloc {}

void main() {
  RepeatsBloc repeatsBloc;
  BasePrefService pref;

  setUp(() async {
    repeatsBloc = MockRepeatsBloc();
    pref = JustCachePrefService();
    await pref.setDefaultValues({
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RepeatsScreen', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(repeatsBloc.state).thenReturn(RepeatsLoading());
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
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
        ),
      );
      await tester.pump();
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
    testWidgets('loaded', (WidgetTester tester) async {
      when(repeatsBloc.state).thenReturn(RepeatsLoaded([
        Repeat(name: 'test', mileageInterval: 0, cars: ['test'])
      ]));
      final repeatsKey = Key('repeats');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(
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
        ),
      );
      await tester.pump();
      expect(find.byKey(repeatsKey), findsOneWidget);
    });
  });
}
