import 'dart:async';
import 'dart:io';

import 'package:autodo/repositories/src/sembast_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';

import 'package:autodo/repositories/repositories.dart';
import '../database/barrel.dart';
import 'event.dart';
import 'state.dart';

class PaidVersionBloc extends Bloc<PaidVersionEvent, PaidVersionState> {
  static const paidVersionId = 'autodo_paid';
  String localVerificationKey;

  final DatabaseBloc _dbBloc;
  final InAppPurchaseConnection _purchaseConn;
  StreamSubscription _dbSubscription, _purchaseSubscription;
  RouteObserver observer = RouteObserver();
  static const platform = const MethodChannel('com.jonathanbayless.autodo/iap');

  PaidVersionBloc({InAppPurchaseConnection conn, @required DatabaseBloc dbBloc})
      : _dbBloc = dbBloc,
        _purchaseConn = conn ?? InAppPurchaseConnection.instance {
    _dbSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadPaidVersion());
      }
    });
    _purchaseSubscription = _purchaseConn.purchaseUpdatedStream.listen((p) {
      for (var purchase in p) {
        if (purchase.status == PurchaseStatus.error) {
          print('Error in purchase: ${purchase.error.message}');
          continue;
        }
        print('status: ${purchase.status} + id: ${purchase.productID}');
        // HACK: App Store payments currently show as pending even when they have been purchased
        if ((purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.pending) &&
            _verifyPurchase(purchase)) {
          add(PaidVersionPurchased());
          print(purchase.skPaymentTransaction);
          // SKPaymentQueueWrapper()..finishTransaction(purchase.skPaymentTransaction);
          // _purchaseConn.completePurchase(purchase);
        }
        if (purchase.status == PurchaseStatus.purchased && Platform.isIOS) {
          print('completing purchase');
          // Mark that you've delivered the purchase. Only the App Store requires
          // this final confirmation.
          _purchaseConn.completePurchase(purchase);
        }
      }
    });
  }

  DataRepository get repo => (_dbBloc.state is DbLoaded)
      ? (_dbBloc.state as DbLoaded).repository
      : null;

  @override
  PaidVersionState get initialState => PaidVersionLoading();

  @override
  Stream<PaidVersionState> mapEventToState(PaidVersionEvent event) async* {
    if (event is LoadPaidVersion) {
      yield* _mapLoadPaidVersionToState(event);
    } else if (event is PaidVersionUpgrade) {
      yield* _mapPaidVersionUpgradeToState(event);
    } else if (event is PaidVersionPurchased) {
      yield PaidVersion();
    }
  }

  /// This methodology will vary by platform, currently just handling Android
  bool _verifyPurchase(PurchaseDetails p) {
    return (p.productID == paidVersionId);
  }

  /// Currently just checking the respective app store, store this on the server
  /// in the future? Would help for transitioning to web app
  Stream<PaidVersionState> _mapLoadPaidVersionToState(event) async* {
    final trialUser = repo is SembastDataRepository;
    if (trialUser) {
      print('trial user');
      yield BasicVersion();
      return;
    }

    // See if we have any pending transactions
    // await SKPaymentQueueWrapper()..restoreTransactions();

    // TODO: pull the JSON purchase validation string from assets bundle

    final QueryPurchaseDetailsResponse response =
        await _purchaseConn.queryPastPurchases();
    if (response.error != null) {
      print('Error querying past purchases: ${response.error.message}');
      yield BasicVersion();
      return;
    }

    print('purchases: ${response.pastPurchases}');
    for (PurchaseDetails p in response.pastPurchases) {
      print('past purchase: $p');
      if (!_verifyPurchase(p)) {
        print('cannot verify purchase');
        continue;
      }
      yield PaidVersion();
      return;
    }

    // Couldn't find any evidence of purchasing the paid version before
    yield BasicVersion();
  }

  Stream<PaidVersionState> _mapPaidVersionUpgradeToState(event) async* {
    final bool available = await _purchaseConn.isAvailable();
    if (!available) {
      return;
    }

    Set<String> ids = Set()..add(paidVersionId);
    final ProductDetailsResponse response =
        await _purchaseConn.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      print('Could not find paid version product id');
      return;
    }
    final deets = response.productDetails[0]; // only care about first item
    final PurchaseParam param = PurchaseParam(productDetails: deets);
    final res = await _purchaseConn.buyNonConsumable(purchaseParam: param);
    if (!res) {
      print('purchase failed');
    }
    // not yielding a new state here, that will come from the purchaseUpdatedStream
  }

  @override
  Future<void> close() {
    _dbSubscription?.cancel();
    _purchaseSubscription?.cancel();
    return super.close();
  }
}
