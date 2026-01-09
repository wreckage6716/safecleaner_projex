import 'package:flutter/material.dart';
import '../services/shizuku_service.dart';

class AppsTab extends StatefulWidget {
  final bool shizukuActive;
  const AppsTab({super.key, required this.shizukuActive});

  @override
  State<AppsTab> createState() => _AppsTabState();
}

class _AppsTabState extends State<AppsTab> {
  final _shizuku = ShizukuService();
  List<Map<String, dynamic>> _apps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() => _loading = true);
    final apps = await _shizuku.getInstalledApps();
    if (mounted) {
      setState(() {
        _apps = apps;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userApps = _apps.where((a) => a['isSystemApp'] == false).toList();
    final systemApps = _apps.where((a) => a['isSystemApp'] == true).toList();

    return RefreshIndicator(
      onRefresh: _loadApps,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _InfoCard(value: '${_apps.length}', label: 'Total', color: const Color(0xFF60A5FA))),
                const SizedBox(width: 8),
                Expanded(child: _InfoCard(value: '${userApps.length}', label: 'User', color: const Color(0xFF34D399))),
                const SizedBox(width: 8),
                Expanded(child: _InfoCard(value: '${systemApps.length}', label: 'System', color: const Color(0xFFFBBF24))),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
            else ...[
              const Text('User Applications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 8),
              ...userApps.take(20).map((app) => _AppItem(
                name: app['appName'] ?? 'Unknown',
                packageName: app['packageName'],
                shizukuActive: widget.shizukuActive,
                isSystem: false,
              )),
              const SizedBox(height: 16),
              const Text('System Applications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 8),
              ...systemApps.take(10).map((app) => _AppItem(
                name: app['appName'] ?? 'Unknown',
                packageName: app['packageName'],
                shizukuActive: widget.shizukuActive,
                isSystem: true,
                badge: 'SYSTEM',
              )),
            ],
          ],
        ),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54)),
        ],
      ),
    );
  }
}

class _AppItem extends StatelessWidget {
  final String name;
  final String packageName;
  final String? badge;
  final bool shizukuActive;
  final bool isSystem;

  const _AppItem({
    required this.name,
    required this.packageName,
    this.badge,
    required this.shizukuActive,
    required this.isSystem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    Text(packageName, style: const TextStyle(fontSize: 9, color: Colors.white38)),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(badge!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.amber)),
                ),
            ],
          ),
          if (shizukuActive && !isSystem) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _ActionButton(
                  label: 'Force Stop',
                  color: const Color(0xFFEF4444),
                  onTap: () => ShizukuService().forceStopApp(packageName),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: 'Clear Data',
                  color: const Color(0xFFFBBF24),
                  onTap: () => ShizukuService().clearAppCache(packageName),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(6)),
            child: Center(child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color))),
          ),
        ),
      ),
    );
  }
}
