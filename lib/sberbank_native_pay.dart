import 'dart:async';

import 'package:flutter/services.dart';

class SberbankNativePay {
  static const MethodChannel _channel =
  const MethodChannel('sberbank_native_pay');

  static Future<String> purchase({String name, double price}) async {
    final String purchaseData = await _channel.invokeMethod('purchase', {
      'name': name,
      'price': price,
    });
    return purchaseData;
  }
}
