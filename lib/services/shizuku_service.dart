import 'package:flutter/services.dart';

class ShizukuService {
  static final ShizukuService _instance = ShizukuService._internal();
  factory ShizukuService() => _instance;
  ShizukuService._internal();

  static const platform = MethodChannel('com.safecleaner.pro/native');
  
  bool _isActive = false;
  bool get isActive => _isActive;

  final List<String> protectedPackages = [
    'android', 'system', 'com.android.systemui', 'com.android.launcher3',
    'com.android.phone', 'com.android.settings', 'com.android.vending',
    'com.android.inputmethod.latin', 'com.android.providers.telephony',
    'com.android.bluetooth', 'com.google.android.gms', 'com.google.android.gsf',
    'com.google.android.googlequicksearchbox', 'com.google.android.apps.messaging',
    'com.samsung.android.incallui', 'com.samsung.android.messaging',
    'com.sec.android.app.launcher', 'com.samsung.android.oneconnect',
    'com.sec.android.inputmethod', 'com.samsung.android.knox.containercore',
    'moe.shizuku.privileged.api', 'com.whatsapp', 'org.telegram.messenger',
  ];

  Future<bool> checkShizukuStatus() async {
    try {
      final result = await platform.invokeMethod('checkShizuku');
      _isActive = result == true;
      return _isActive;
    } catch (e) {
      _isActive = false;
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getInstalledApps');
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, int>> getStorageInfo() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getStorageInfo');
      return Map<String, int>.from(result);
    } catch (e) {
      return {'total': 0, 'available': 0, 'used': 0};
    }
  }

  Future<Map<String, int>> getMemoryInfo() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getMemoryInfo');
      return Map<String, int>.from(result);
    } catch (e) {
      return {'total': 0, 'available': 0, 'used': 0};
    }
  }

  Future<double> getCpuUsage() async {
    try {
      final double result = await platform.invokeMethod('getCpuUsage');
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  Future<String> executeCommand(String command) async {
    if (!_isActive) {
      // Fallback to normal shell if Shizuku not active (limited)
      try {
        final result = await platform.invokeMethod('executeShizukuCommand', {'command': command});
        return result ?? '';
      } catch (e) {
        return 'Error: $e';
      }
    }
    try {
      final result = await platform.invokeMethod('executeShizukuCommand', {'command': command});
      return result ?? '';
    } catch (e) {
      throw Exception('Command failed: $e');
    }
  }

  Future<bool> forceStopApp(String packageName) async {
    if (protectedPackages.contains(packageName)) return false;
    try {
      await executeCommand('am force-stop $packageName');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAppCache(String packageName) async {
    if (protectedPackages.contains(packageName)) return false;
    try {
      await executeCommand('pm clear $packageName');
      return true;
    } catch (e) {
      return false;
    }
  }
}
