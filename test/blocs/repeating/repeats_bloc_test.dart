import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/repositories/barrel.dart';

class MockDataRepository extends Mock implements DataRepository {}
class MockWriteBatch extends Mock implements WriteBatchWrapper {}

void main() {
  group('RepeatsBloc', () {
    test('Null Assertion', () {
      expect(() => RepeatsBloc(dataRepository: null), throwsAssertionError);
    });
    group('LoadRepeats', () {
      blocTest<RepeatsBloc, RepeatsEvent, RepeatsState>( 
        'Successful',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.repeats())
            .thenAnswer((_) => Stream.fromIterable([[Repeat()]]));
          return RepeatsBloc(dataRepository: dataRepository);
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
          return RepeatsBloc(dataRepository: dataRepository);
        },
        act: (bloc) async => bloc.add(LoadRepeats()),
        expect: [
          RepeatsLoading(),
          RepeatsNotLoaded()
        ],
      );
      blocTest<RepeatsBloc, RepeatsEvent, RepeatsState>( 
        'exception',
        build: () {
          final dataRepository = MockDataRepository();
          when(dataRepository.repeats())
            .thenThrow((_) => Exception());
          return RepeatsBloc(dataRepository: dataRepository);
        },
        act: (bloc) async => bloc.add(LoadRepeats()),
        expect: [
          RepeatsLoading(),
          RepeatsNotLoaded()
        ],
      );
    });
    blocTest('AddRepeat', 
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.repeats())
          .thenAnswer((_) => 
            Stream.fromIterable(
              [[Repeat()]]
          ));
        return RepeatsBloc(dataRepository: dataRepository);
      },
      act: (bloc) async {
        bloc.add(LoadRepeats());
        bloc.add(AddRepeat(Repeat()));
      },
      expect: [ 
        RepeatsLoading(),
        RepeatsLoaded([Repeat()]),
        RepeatsLoaded([Repeat(), Repeat()]),
      ],
    );
    blocTest('UpdateRepeat', 
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.repeats())
          .thenAnswer((_) => 
            Stream.fromIterable(
              [[Repeat(id: '0', name: 'test')]]
          ));
        return RepeatsBloc(dataRepository: dataRepository);
      },
      act: (bloc) async {
        bloc.add(LoadRepeats());
        bloc.add(UpdateRepeat(Repeat(id: '0', name: 'abcd')));
      },
      expect: [ 
        RepeatsLoading(),
        RepeatsLoaded([Repeat(id: '0', name: 'test')]),
        RepeatsLoaded([Repeat(id: '0', name: 'abcd')]),
      ],
    );
    blocTest('DeleteRepeat', 
      build: () {
        final dataRepository = MockDataRepository();
        when(dataRepository.repeats())
          .thenAnswer((_) => 
            Stream.fromIterable(
              [[Repeat(id: '0')]]
          ));
        return RepeatsBloc(dataRepository: dataRepository);
      },
      act: (bloc) async {
        bloc.add(LoadRepeats());
        bloc.add(DeleteRepeat(Repeat(id: '0')));
      },
      expect: [ 
        RepeatsLoading(),
        RepeatsLoaded([Repeat(id: '0')]),
        RepeatsLoaded([]),
      ],
    );
    blocTest('AddDefaultRepeats', 
      build: () {
        final dataRepository = MockDataRepository();
        final mockBatch = MockWriteBatch();
        when(dataRepository.startRepeatWriteBatch())
          .thenAnswer((_) => mockBatch);
        // dynamic lambdas to effectively do nothing
        when(mockBatch.setData(dynamic)).thenAnswer((_) => ((_) => _)); 
        when(mockBatch.commit()).thenAnswer((_) => (() => _));
        return RepeatsBloc(dataRepository: dataRepository);
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