import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class PermissionService {
  static const platform = MethodChannel('com.safecleaner.pro/native');

  static Future<bool> requestStoragePermissions() async {
    // Android 11+ (API 30+)
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }
    
    // Fallback untuk Android lama
    final status = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
    
    return status.values.every((s) => s.isGranted);
  }

  static Future<bool> hasStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) return true;
    return await Permission.storage.isGranted;
  }

  static Future<bool> requestUsageStats() async {
    // Karena permission_handler tidak mendukung packageUsageStats secara native,
    // kita panggil via native bridge di MainActivity.kt
    try {
      final bool granted = await platform.invokeMethod('checkUsageStatsPermission');
      if (!granted) {
        await platform.invokeMethod('openUsageStatsSettings');
      }
      return granted;
    } catch (e) {
      return false;
    }
  }
}
