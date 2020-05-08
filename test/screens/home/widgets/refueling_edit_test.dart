import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/screens/home/widgets/refueling_edit_button.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

class MockRefuelingsBloc extends MockBloc<RefuelingsEvent, RefuelingsState> implements RefuelingsBloc {}

void main() {
  BasePrefService pref;
  CarsBloc carsBloc;
  RefuelingsBloc refuelingsBloc;
  final refueling = Refueling(  
    amount: 10.0,
    date: DateTime.fromMillisecondsSinceEpoch(0),
    mileage: 10.0,
    cost: 10.0,
    carName: 'test'
  );

  setUp(() async {
    carsBloc = MockCarsBloc();
    when(carsBloc.state).thenReturn(CarsLoaded([Car()])); // need a car in the list to save
    refuelingsBloc = MockRefuelingsBloc();
    pref = JustCachePrefService();
    await pref.setDefaultValues({  
      'length_unit': DistanceUnit.imperial.index,
      'volume_unit': VolumeUnit.us.index,
      'currency': 'USD',
    });
  });

  group('RefuelingEditButton', () {
    testWidgets('renders', (WidgetTester tester) async {
      final refuelingsKey = Key('refuelings');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(  
            providers: [
              BlocProvider<CarsBloc>.value(value: carsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingEditButton(key: refuelingsKey, refueling: refueling),
              ),
            ),
          ),
        )
      );
      await tester.pumpAndSettle();
      expect(find.byKey(refuelingsKey), findsOneWidget);
    });
    testWidgets('press', (WidgetTester tester) async {
      final todosKey = Key('todos');
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(  
            providers: [
              BlocProvider<CarsBloc>.value(value: carsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingEditButton(key: todosKey, refueling: refueling),
              ),
            ),
          ),
        )
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pumpAndSettle();

      expect(find.byType(RefuelingAddEditScreen), findsOneWidget);
    });
    testWidgets('press and save', (WidgetTester tester) async {
      final todosKey = Key('todos');
      var _saved = false;
      when(refuelingsBloc.add(any)).thenAnswer((realInvocation) {
        _saved = true;
      });
      await tester.pumpWidget(
        ChangeNotifierProvider<BasePrefService>.value(
          value: pref,
          child: MultiBlocProvider(  
            providers: [
              BlocProvider<CarsBloc>.value(value: carsBloc),
              BlocProvider<RefuelingsBloc>.value(value: refuelingsBloc),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RefuelingEditButton(key: todosKey, refueling: refueling),
              ),
            ),
          ),
        )
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(todosKey));
      await tester.pumpAndSettle();

      expect(find.byType(RefuelingAddEditScreen), findsOneWidget);
      
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(_saved, true);
    });
  });
}
