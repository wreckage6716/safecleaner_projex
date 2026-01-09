import 'package:flutter/material.dart';
import '../services/shizuku_service.dart';
import '../services/file_scanner_service.dart';
import '../widgets/storage_card.dart';
import '../widgets/category_card.dart';

class CleanTab extends StatefulWidget {
  final bool shizukuActive;
  const CleanTab({super.key, required this.shizukuActive});

  @override
  State<CleanTab> createState() => _CleanTabState();
}

class _CleanTabState extends State<CleanTab> {
  final _shizuku = ShizukuService();
  final _scanner = FileScannerService();
  
  Map<String, int> _storage = {'total': 0, 'available': 0, 'used': 0};
  Map<String, int> _cacheStats = {'size': 0, 'count': 0};
  Map<String, int> _apkStats = {'size': 0, 'count': 0};
  bool _loading = true;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _refreshInfo();
  }

  Future<void> _refreshInfo() async {
    final storage = await _shizuku.getStorageInfo();
    if (mounted) {
      setState(() {
        _storage = storage;
        _loading = false;
      });
    }
  }

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    
    // Real scan process
    final cache = await _scanner.scanCacheFiles();
    final apks = await _scanner.scanApkFiles();
    
    if (mounted) {
      setState(() {
        _cacheStats = cache;
        _apkStats = apks;
        _scanning = false;
      });
      _showResults();
    }
  }

  void _showResults() {
    final totalFreed = _cacheStats['size']! + _apkStats['size']!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Scan Complete'),
        content: Text(
          'Found:\n'
          '• ${_scanner.formatBytes(_cacheStats['size']!)} cache\n'
          '• ${_scanner.formatBytes(_apkStats['size']!)} APK files\n'
          '• 0 B duplicates (deep scan req.)\n\n'
          'Total selectable: ${_scanner.formatBytes(totalFreed)}'
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  double _toGB(int bytes) => bytes / (1024 * 1024 * 1024);

  @override
  Widget build(BuildContext context) {
    final usedGB = _toGB(_storage['used'] ?? 0);
    final totalGB = _toGB(_storage['total'] ?? 0);
    final percent = (_storage['total'] ?? 0) > 0 
        ? ((_storage['used']! / _storage['total']!) * 100).toInt() 
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StorageCard(
            usedSpace: double.parse(usedGB.toStringAsFixed(1)),
            totalSpace: double.parse(totalGB.toStringAsFixed(1)),
            usedPercent: percent,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _scanning ? null : _startScan,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: _scanning 
                    ? LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade700]) 
                    : const LinearGradient(colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _scanning ? [] : [BoxShadow(color: const Color(0xFF60A5FA).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_scanning) 
                    const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                  else 
                    const Icon(Icons.radar, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(_scanning ? 'Scanning...' : 'Start Deep Scan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Cleaning Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          CategoryCard(
            icon: Icons.cached_rounded,
            title: 'Cache Files',
            subtitle: 'System and apps',
            size: _scanner.formatBytes(_cacheStats['size']!),
            count: '${_cacheStats['count']} items',
            color: const Color(0xFF60A5FA),
            onTap: () {},
          ),
          const SizedBox(height: 8),
          CategoryCard(
            icon: Icons.insert_drive_file_rounded,
            title: 'APK Files',
            subtitle: 'Downloads folder',
            size: _scanner.formatBytes(_apkStats['size']!),
            count: '${_apkStats['count']} items',
            color: const Color(0xFF34D399),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
