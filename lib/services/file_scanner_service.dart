import 'dart:io';

class FileScannerService {
  static final FileScannerService _instance = FileScannerService._internal();
  factory FileScannerService() => _instance;
  FileScannerService._internal();

  Future<Map<String, int>> scanCacheFiles() async {
    int totalSize = 0;
    int count = 0;
    try {
      final dir = Directory('/storage/emulated/0/Android/data');
      if (await dir.exists()) {
        await for (var entity in dir.list(recursive: true)) {
          if (entity is File && entity.path.contains('/cache/')) {
            try {
              final stat = await entity.stat();
              totalSize += stat.size;
              count++;
            } catch (e) {
              // Failed to get stats for a file
            }
          }
        }
      }
    } catch (e) {
      // Failed to scan cache files
    }
    return {'size': totalSize, 'count': count};
  }

  Future<Map<String, int>> scanApkFiles() async {
    int totalSize = 0;
    int count = 0;
    try {
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) {
        await for (var entity in dir.list()) {
          if (entity is File && entity.path.endsWith('.apk')) {
            try {
              final stat = await entity.stat();
              totalSize += stat.size;
              count++;
            } catch (e) {
              // Failed to get stats for a file
            }
          }
        }
      }
    } catch (e) {
      // Failed to scan APK files
    }
    return {'size': totalSize, 'count': count};
  }

  Future<bool> deleteCacheFiles() async {
    try {
      final dir = Directory('/storage/emulated/0/Android/data');
      if (await dir.exists()) {
        await for (var entity in dir.list(recursive: true)) {
          if (entity is File && entity.path.contains('/cache/')) {
            try {
              await entity.delete();
            } catch (e) {
              // Failed to delete a file
            }
          }
        }
      }
      return true;
    } catch (e) {
      // Failed to delete cache files
      return false;
    }
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }
}