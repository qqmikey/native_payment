import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sberbank_native_pay/sberbank_native_pay.dart';

void main() {
  const MethodChannel channel = MethodChannel('sberbank_native_pay');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect('42', '42');
  });
}
