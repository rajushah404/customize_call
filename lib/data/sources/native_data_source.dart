import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class NativeDataSource {
  static const _channel = MethodChannel('com.example.call_rejecter/call_screening');

  Future<bool> isDefaultApp() async {
    try {
      final bool status = await _channel.invokeMethod('isDefaultApp');
      return status;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<void> requestDefaultApp() async {
    try {
      await _channel.invokeMethod('requestDefaultApp');
    } on PlatformException catch (_) {
      // Handle error
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.phone,
      Permission.contacts,
    ].request();
  }
}
