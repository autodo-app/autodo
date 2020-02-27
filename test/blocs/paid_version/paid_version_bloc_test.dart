import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/repositories/src/sembast_data_repository.dart';

// ignore: must_be_immutable
class MockDataRepository extends Mock
    with EquatableMixin
    implements DataRepository {}

// ignore: must_be_immutable
class MockSembast extends Mock
    with EquatableMixin
    implements SembastDataRepository {}

class MockDbBloc extends Mock implements DatabaseBloc {}

class MockInAppPurchaseConnection extends Mock
    implements InAppPurchaseConnection {}

void main() {
  group('PaidVersionBloc', () {
    final DataRepository dataRepo = MockDataRepository();
    final SembastDataRepository sembast = MockSembast();
    final InAppPurchaseConnection conn = MockInAppPurchaseConnection();
    final emptyVerificationData = PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: '',
        source: IAPSource.GooglePlay);
    final emptyDetails = PurchaseDetails(
        productID: '',
        purchaseID: '',
        transactionDate: '',
        verificationData: emptyVerificationData);
    final validDetails = PurchaseDetails(
        productID: 'autodo_paid',
        purchaseID: '',
        transactionDate: '',
        verificationData: emptyVerificationData);

    group('LoadPaidVersion', () {
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'no valid purchases',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.queryPastPurchases()).thenAnswer((_) async =>
                QueryPurchaseDetailsResponse(pastPurchases: [emptyDetails]));

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), BasicVersion()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'valid purchase',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.queryPastPurchases()).thenAnswer((_) async =>
                QueryPurchaseDetailsResponse(pastPurchases: [validDetails]));

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), PaidVersion()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'trial version',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.queryPastPurchases()).thenAnswer((_) async =>
                QueryPurchaseDetailsResponse(pastPurchases: [emptyDetails]));

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(sembast));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), BasicVersion()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'response error',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.queryPastPurchases()).thenAnswer((_) async =>
                QueryPurchaseDetailsResponse(
                    pastPurchases: [],
                    error: IAPError(
                        code: '', message: '', source: IAPSource.GooglePlay)));

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), BasicVersion()]);
    });

    group('PaidVersionUpgrade', () {
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'not available',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.isAvailable()).thenAnswer((_) async => false);

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(PaidVersionUpgrade()),
          expect: [PaidVersionLoading()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'could not find id',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.isAvailable()).thenAnswer((_) async => true);
            final ids = <String>{'autodo_paid'};
            when(conn.queryProductDetails(ids)).thenAnswer((_) async =>
                ProductDetailsResponse(productDetails: [], notFoundIDs: ['']));

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(PaidVersionUpgrade()),
          expect: [PaidVersionLoading()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'failed purchase',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.isAvailable()).thenAnswer((_) async => true);
            final ids = <String>{'autodo_paid'};
            final deets = ProductDetails(
                id: 'autodo_paid', price: '', title: '', description: '');
            when(conn.queryProductDetails(ids)).thenAnswer((_) async =>
                ProductDetailsResponse(
                    productDetails: [deets], notFoundIDs: []));
            when(conn.buyNonConsumable(
                    purchaseParam: anyNamed('purchaseParam')))
                .thenAnswer((_) async => false);

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(PaidVersionUpgrade()),
          expect: [PaidVersionLoading()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'successful purchase',
          build: () {
            when(conn.purchaseUpdatedStream)
                .thenAnswer((_) => Stream.fromIterable([]));
            when(conn.isAvailable()).thenAnswer((_) async => true);
            final ids = <String>{'autodo_paid'};
            final deets = ProductDetails(
                id: 'autodo_paid', price: '', title: '', description: '');
            when(conn.queryProductDetails(ids)).thenAnswer((_) async =>
                ProductDetailsResponse(
                    productDetails: [deets], notFoundIDs: []));
            when(conn.buyNonConsumable(
                    purchaseParam: anyNamed('purchaseParam')))
                .thenAnswer((_) async => false);

            final dbBloc = MockDbBloc();
            when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
            return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
          },
          act: (bloc) async => bloc.add(PaidVersionUpgrade()),
          expect: [PaidVersionLoading()]);
    });

    group('listeners', () {
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>('dbBloc',
          build: () {
        when(conn.purchaseUpdatedStream)
            .thenAnswer((_) => Stream.fromIterable([]));

        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
        whenListen(dbBloc, Stream.fromIterable([DbLoaded(sembast)]));
        return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
      },
          // act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), BasicVersion()]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'conn, not purchased', build: () {
        final details = validDetails;
        details.status = PurchaseStatus.error;
        details.error =
            IAPError(code: '', message: '', source: IAPSource.GooglePlay);
        when(conn.purchaseUpdatedStream).thenAnswer((_) => Stream.fromIterable([
              [details],
            ]));

        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
        return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
      },
          // act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [
            PaidVersionLoading(),
          ]);
      blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
          'conn, purchased', build: () {
        final details = validDetails;
        details.status = PurchaseStatus.purchased;
        when(conn.purchaseUpdatedStream).thenAnswer((_) => Stream.fromIterable([
              [details],
            ]));

        final dbBloc = MockDbBloc();
        when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
        return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
      },
          // act: (bloc) async => bloc.add(LoadPaidVersion()),
          expect: [PaidVersionLoading(), PaidVersion()]);
    });

    blocTest<PaidVersionBloc, PaidVersionEvent, PaidVersionState>(
        'PaidVersionPurchased',
        build: () {
          when(conn.purchaseUpdatedStream)
              .thenAnswer((_) => Stream.fromIterable([]));
          when(conn.isAvailable()).thenAnswer((_) async => false);

          final dbBloc = MockDbBloc();
          when(dbBloc.state).thenReturn(DbLoaded(dataRepo));
          return PaidVersionBloc(conn: conn, dbBloc: dbBloc);
        },
        act: (bloc) async => bloc.add(PaidVersionPurchased()),
        expect: [PaidVersionLoading(), PaidVersion()]);
  });
}
