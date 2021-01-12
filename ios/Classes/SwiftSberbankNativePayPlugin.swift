import Flutter
import UIKit
import PassKit


enum Methods: String {
    case purchaseEvent = "purchase"
}

enum Arguments: String {
    case name = "name"
    case price = "price"
}

public class SwiftSberbankNativePayPlugin: NSObject, FlutterPlugin, PKPaymentAuthorizationViewControllerDelegate {
    
    var vc : UIViewController?
    var resultHandler: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sberbank_native_pay", binaryMessenger: registrar.messenger())
        let instance = SwiftSberbankNativePayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let rootViewController:UIViewController! = UIApplication.shared.keyWindow?.rootViewController
        vc = rootViewController
        resultHandler = result
        switch call.method {
        case Methods.purchaseEvent.rawValue:
            purchaseHandler(with: call)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func purchaseHandler(with call: FlutterMethodCall) {
        
        guard let name: String  = getArgument(Arguments.name.rawValue, from: call.arguments) else {
            return self.resultHandler!(FlutterError(code: "APPLE_PAY_ERROR",message: "No name passed",details: nil))
        }
        
        guard let price: Double  = getArgument(Arguments.price.rawValue, from: call.arguments) else {
            return self.resultHandler!(FlutterError(code: "APPLE_PAY_ERROR",message: "No name passed",details: nil))
        }
        
        let paymentItem = PKPaymentSummaryItem.init(label: name, amount: NSDecimalNumber(value: price))
        if #available(iOS 9.0, *) {
            let paymentNetworks = [PKPaymentNetwork.discover, .masterCard, .visa]
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                let request = PKPaymentRequest()
                request.currencyCode = "RUB"
                request.countryCode = "RU"
                request.merchantIdentifier = "merchant.com.keyfactor.tyumentourizm"
                request.merchantCapabilities = PKMerchantCapability.capability3DS
                request.supportedNetworks = paymentNetworks
                request.paymentSummaryItems = [paymentItem]
                
                guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                    self.resultHandler!(FlutterError(code: "APPLE_PAY_ERROR",message: "Unable to present Apple Pay",details: nil))
                    return
                }
                paymentVC.delegate = self
                self.vc?.present(paymentVC, animated:true, completion:nil)
            } else {
                self.resultHandler!(FlutterError(code: "APPLE_PAY_ERROR",message: "Payments disabled",details: nil))
            }
        } else {
            self.resultHandler!(FlutterError(code: "APPLE_PAY_ERROR",message: "Payments disabled",details: nil))
        }
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: {
            self.resultHandler!(FlutterError.init(code: "APPLE_PAY_ERROR",message: "Payment cancelled",details: nil))
        })
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        self.resultHandler!(payment.token.paymentData.base64EncodedString())
    }
    
    private func getArgument<T>(_ name: String, from arguments: Any?) -> T? {
        guard let arguments = arguments as? [String: Any] else { return nil }
        return arguments[name] as? T
    }
}
