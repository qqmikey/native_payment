#import "SberbankNativePayPlugin.h"
#if __has_include(<sberbank_native_pay/sberbank_native_pay-Swift.h>)
#import <sberbank_native_pay/sberbank_native_pay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sberbank_native_pay-Swift.h"
#endif

@implementation SberbankNativePayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSberbankNativePayPlugin registerWithRegistrar:registrar];
}
@end
