import 'package:flutter/material.dart';
import '../services/shizuku_service.dart';
import '../services/permission_service.dart';
import 'clean_tab.dart';
import 'performance_tab.dart';
import 'apps_tab.dart';
import 'tools_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _shizukuActive = false;
  final _shizukuService = ShizukuService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkShizuku();
  }

  Future<void> _initialize() async {
    await PermissionService.requestStoragePermissions();
    await _checkShizuku();
  }

  Future<void> _checkShizuku() async {
    final active = await _shizukuService.checkShizukuStatus();
    if (mounted) setState(() => _shizukuActive = active);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      CleanTab(shizukuActive: _shizukuActive),
      PerformanceTab(shizukuActive: _shizukuActive),
      AppsTab(shizukuActive: _shizukuActive),
      ToolsTab(shizukuActive: _shizukuActive),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('SafeCleaner Pro', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [
          GestureDetector(
            onTap: _checkShizuku,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _shizukuActive ? const Color(0xFF34D399).withOpacity(0.15) : const Color(0xFFEF4444).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _shizukuActive ? const Color(0xFF34D399) : const Color(0xFFEF4444)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_shizukuActive ? Icons.shield_outlined : Icons.shield, size: 14, color: _shizukuActive ? const Color(0xFF34D399) : const Color(0xFFEF4444)),
                  const SizedBox(width: 4),
                  Text(_shizukuActive ? 'Protected' : 'Limited', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _shizukuActive ? const Color(0xFF34D399) : const Color(0xFFEF4444))),
                ],
              ),
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0A0A0A), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.cleaning_services_rounded, label: 'Clean', active: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
              _NavItem(icon: Icons.speed_rounded, label: 'Performance', active: _currentIndex == 1, onTap: () => setState(() => _currentIndex = 1)),
              _NavItem(icon: Icons.apps_rounded, label: 'Apps', active: _currentIndex == 2, onTap: () => setState(() => _currentIndex = 2)),
              _NavItem(icon: Icons.build_rounded, label: 'Tools', active: _currentIndex == 3, onTap: () => setState(() => _currentIndex = 3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: active ? const Color(0xFF60A5FA).withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? const Color(0xFF60A5FA) : Colors.grey, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? const Color(0xFF60A5FA) : Colors.grey)),
          ],
        ),
      ),
    );
  }
}