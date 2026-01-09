import 'package:flutter/material.dart';

class ToolsTab extends StatelessWidget {
  final bool shizukuActive;
  const ToolsTab({super.key, required this.shizukuActive});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Power Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          
          // ADB Connection Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ADB Connection', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('USB', style: TextStyle(fontSize: 10, color: Colors.white54)),
                          SizedBox(height: 2),
                          Text('Connected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF34D399))),
                          Text('4200823...', style: TextStyle(fontSize: 9, color: Colors.white24)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Wi-Fi', style: TextStyle(fontSize: 10, color: Colors.white54)),
                          SizedBox(height: 2),
                          Text('Offline', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                          Text('Not setup', style: TextStyle(fontSize: 9, color: Colors.white24)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_input_antenna, size: 18),
                    label: const Text('Setup Wireless'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60A5FA).withOpacity(0.15),
                      foregroundColor: const Color(0xFF60A5FA),
                      side: const BorderSide(color: Color(0xFF60A5FA)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Actions Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.5,
                  children: [
                    _QuickActionButton(label: 'Clear Cache', color: const Color(0xFF60A5FA), onTap: () {}),
                    _QuickActionButton(label: 'Stop BG', color: const Color(0xFFEF4444), onTap: () {}),
                    _QuickActionButton(label: 'DB Optimize', color: const Color(0xFF60A5FA), onTap: () {}),
                    _QuickActionButton(label: 'Permissions', color: const Color(0xFF34D399), onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Protected Packages
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Protected Packages (22)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                  '• android, system, systemui\n'
                  '• phone, settings, gms, gsf\n'
                  '• samsung launcher & keyboard\n'
                  '• whatsapp, telegram, shizuku',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // System Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('System Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _SystemInfoItem(label: 'Android', value: '8.0.0')),
                    Expanded(child: _SystemInfoItem(label: 'Device', value: 'J5 Prime')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _SystemInfoItem(label: 'RAM', value: '2 GB')),
                    Expanded(child: _SystemInfoItem(label: 'Storage', value: '16 GB')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _SystemInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _SystemInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
