import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/repositories/repositories.dart';

// ignore: must_be_immutable
class MockDataRepository extends Mock implements FirebaseDataRepository {}

// ignore: must_be_immutable
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

class MockDbBloc extends Mock implements DatabaseBloc {}

class MockCarsBloc extends MockBloc<CarsEvent, CarsState> implements CarsBloc {}

void main() {
  group('RepeatsBloc', () {
    final CarsBloc carsBloc = MockCarsBloc();
    test('Null Assertion', () {
      expect(() => RepeatsBloc(dbBloc: null), throwsAssertionError);
    });
    group('LoadRepeats', () {
      blocTest<RepeatsBloc, RepeatsEvent, RepeatsState>(
        'Successful',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.repeats()).thenAnswer((_) => Stream.fromIterable([
                [Repeat()]
              ]));
          when(dataRepository.getCurrentRepeats())
              .thenAnswer((_) async => [Repeat()]);
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRepeats()),
        expect: [
          RepeatsLoading(),
          RepeatsLoaded([Repeat()])
        ],
      );
      blocTest<RepeatsBloc, RepeatsEvent, RepeatsState>(
        'Null Repeats',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.repeats())
              .thenAnswer((_) => Stream.fromIterable([null]));
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          when(dataRepository.getCurrentRepeats()).thenAnswer((_) async => []);
          return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRepeats()),
        expect: [RepeatsLoading(), RepeatsLoaded([])],
      );
      blocTest<RepeatsBloc, RepeatsEvent, RepeatsState>(
        'exception',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.repeats()).thenAnswer((_) => null);
          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
          return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
        },
        act: (bloc) async => bloc.add(LoadRepeats()),
        expect: [RepeatsLoading(), RepeatsNotLoaded()],
      );
    });
    final dataRepository = MockDataRepository();
    // XXX: this isn't recognizing the state with only one repeat for some reason
    // It seems to be a bloc_test issue
    // blocTest(
    //   'AddRepeat',
    //   build: () {
    //     final dbBloc = MockDbBloc();
    //     when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
    //     when(dataRepository.getCurrentRepeats())
    //         .thenAnswer((_) async => [Repeat(name: 'test')]);
    //     return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc)..add(LoadRepeats());
    //   },
    //   act: (bloc) async {
    //     bloc.add(LoadRepeats());
    //     bloc.add(AddRepeat(Repeat(name: 'test2')));
    //   },
    //   expect: [
    //     RepeatsLoading(),
    //     RepeatsLoaded([Repeat(name: 'test')]),
    //     RepeatsLoaded([Repeat(name: 'test'), Repeat(name: 'test2')]),
    //   ],
    //   wait: Duration(milliseconds: 200)
    // );
    test('AddRepeat', () async {
      final dbBloc = MockDbBloc();
      when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
      when(dataRepository.getCurrentRepeats())
          .thenAnswer((_) async => [Repeat(name: 'test')]);
      final bloc = RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc)
        ..add(LoadRepeats());
      assert(bloc.state == RepeatsLoading());
      bloc.add(LoadRepeats());
      await Future.delayed(Duration(milliseconds: 200));
      assert(bloc.state == RepeatsLoaded([Repeat(name: 'test')]));
      bloc.add(AddRepeat(Repeat(name: 'test2')));
      await Future.delayed(Duration(milliseconds: 200));
      assert(bloc.state ==
          RepeatsLoaded([Repeat(name: 'test'), Repeat(name: 'test2')]));
    });
    blocTest(
      'UpdateRepeat',
      build: () {
        when(dataRepository.repeats()).thenAnswer((_) => Stream.fromIterable([
              [Repeat(id: '0', name: 'test')]
            ]));
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        when(dataRepository.getCurrentRepeats())
            .thenAnswer((_) async => [Repeat(id: '0', name: 'test')]);
        return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRepeats());
        bloc.add(UpdateRepeat(Repeat(id: '0', name: 'abcd')));
        // update the repository accordingly
        await Future.doWhile(() async {
          await Future.delayed(Duration(milliseconds: 50));
          if (bloc.state is RepeatsLoading) {
            return true;
          } else {
            return false;
          }
        });
        when(dataRepository.getCurrentRepeats())
            .thenAnswer((_) async => [Repeat(id: '0', name: 'abcd')]);
        bloc.add(LoadRepeats());
      },
      expect: [
        RepeatsLoading(),
        RepeatsLoaded([Repeat(id: '0', name: 'test')]),
        RepeatsLoaded([Repeat(id: '0', name: 'abcd')]),
      ],
    );
    blocTest(
      'DeleteRepeat',
      build: () {
        final dataRepository = MockDataRepository();
        final repeats = [Repeat(id: '0')];
        when(dataRepository.repeats())
            .thenAnswer((_) => Stream.fromIterable([repeats]));
        when(dataRepository.deleteRepeat(Repeat(id: '0')))
            .thenAnswer((_) => null);
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        when(dataRepository.getCurrentRepeats())
            .thenAnswer((_) async => [Repeat(id: '0')]);
        return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(LoadRepeats());
        bloc.add(DeleteRepeat(Repeat(id: '0')));
      },
      expect: [
        RepeatsLoading(),
        RepeatsLoaded([Repeat(id: '0')]),
        RepeatsLoaded([]),
        RepeatsLoaded([
          Repeat(id: '0')
        ]), // not really sure how to mock the behavior where this responds later with an empty version
      ],
    );
    blocTest(
      'AddDefaultRepeats',
      build: () {
        final dataRepository = MockDataRepository();
        final mockBatch = MockWriteBatch();
        when(dataRepository.startRepeatWriteBatch())
            .thenAnswer((_) => mockBatch);
        when(dataRepository.repeats())
            .thenAnswer((_) => Stream.fromIterable([RepeatsBloc.defaults]));
        when(dataRepository.getCurrentRepeats())
            .thenAnswer((_) async => RepeatsBloc.defaults);
        // dynamic lambdas to effectively do nothing
        when(mockBatch.setData(dynamic)).thenAnswer((_) => (_) => _);
        when(mockBatch.commit()).thenAnswer((_) async {});
        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenAnswer((_) => DbLoaded(dataRepository));
        return RepeatsBloc(dbBloc: dbBloc, carsBloc: carsBloc);
      },
      act: (bloc) async {
        bloc.add(AddDefaultRepeats());
      },
      expect: [
        RepeatsLoading(),
        RepeatsLoaded(RepeatsBloc.defaults),
      ],
    );
  });
}
