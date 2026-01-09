import 'package:flutter/material.dart';
import 'dart:async';
import '../services/shizuku_service.dart';

class PerformanceTab extends StatefulWidget {
  final bool shizukuActive;
  const PerformanceTab({super.key, required this.shizukuActive});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> {
  final _shizuku = ShizukuService();
  Timer? _timer;
  Map<String, int> _memInfo = {'total': 0, 'available': 0, 'used': 0};
  double _cpuUsage = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => _fetchStats());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    final mem = await _shizuku.getMemoryInfo();
    final cpu = await _shizuku.getCpuUsage();
    if (mounted) {
      setState(() {
        _memInfo = mem;
        _cpuUsage = cpu;
        _loading = false;
      });
    }
  }

  String _formatGB(int bytes) => (bytes / (1024 * 1024 * 1024)).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Monitor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  value: '${_formatGB(_memInfo['used'] ?? 0)} GB',
                  label: 'RAM Used / ${_formatGB(_memInfo['total'] ?? 0)} GB',
                  color: const Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoCard(
                  value: '${_cpuUsage.toStringAsFixed(1)}%',
                  label: 'CPU Usage',
                  color: const Color(0xFF34D399),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressBar(
            label: 'RAM Load',
            percent: (_memInfo['total'] ?? 0) > 0 ? (_memInfo['used']! / _memInfo['total']!) : 0,
            color: const Color(0xFF60A5FA),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.speed, color: Color(0xFFFBBF24), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('System Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(
                        _cpuUsage > 80 ? 'Heavy Load Detected' : 'System running smoothly',
                        style: TextStyle(fontSize: 10, color: _cpuUsage > 80 ? Colors.red : Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Hardware Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _HardwareItem(label: 'Architecture', value: 'arm64-v8a'),
          _HardwareItem(label: 'Memory Limit', value: '${_formatGB(_memInfo['threshold'] ?? 0)} GB (Critical)'),
          _HardwareItem(label: 'Low RAM Mode', value: (_memInfo['lowMemory'] == 1) ? 'Yes' : 'No'),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _InfoCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  const _ProgressBar({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
            Text('${(percent * 100).toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _HardwareItem extends StatelessWidget {
  final String label;
  final String value;
  const _HardwareItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
