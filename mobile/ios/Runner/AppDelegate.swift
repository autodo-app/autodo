import UIKit
import Flutter
import StoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var products : [SKProduct] = []

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    IAPManager.shared.getProducts { (result) in
        DispatchQueue.main.async {
            switch result {
                case .success(let products): self.products = products
                case .failure(_): return
            }
        }
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let iapChannel = FlutterMethodChannel(name: "com.autodo.autodo/iap",
                                          binaryMessenger: controller.binaryMessenger)
    iapChannel.setMethodCallHandler(handle)

    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "fetchPurchases" {
          self.fetchPurchases(result: result)
        } else if call.method == "buy" {
          result(self.purchase(item: 0))
        } else {
          result(FlutterMethodNotImplemented)
        }
    }

  private func purchase(item: Int) -> Bool {

    if !IAPManager.shared.canMakePayments() {
      return false
    } else {
      let productNil : SKProduct? = self.products.indices.contains(0) ? self.products[0] : nil
      if productNil == nil {
        return false
      }
      let product : SKProduct = productNil!
      IAPManager.shared.buy(product: product) { (result) in
          DispatchQueue.main.async {
            print("here")
              // self.delegate?.didFinishLongProcess()

//              switch result {
//                // case .success(_): self.updateGameDataWithPurchasedProduct(product)
//                case .success(_):
//                case .failure(_):
//                // case .failure(let error): self.delegate?.showIAPRelatedError(error)
//              }
          }
      }
      return true
    }
  }

  private func fetchPurchases(result: FlutterResult) {
    result(Int())
  }
}


