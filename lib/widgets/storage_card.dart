import 'package:flutter/material.dart';

class StorageCard extends StatelessWidget {
  final double usedSpace;
  final double totalSpace;
  final int usedPercent;

  const StorageCard({super.key, required this.usedSpace, required this.totalSpace, required this.usedPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF60A5FA).withOpacity(0.2), const Color(0xFF34D399).withOpacity(0.1)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Storage Status', style: TextStyle(fontSize: 14, color: Colors.white70)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFBBF24).withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text('$usedPercent% Used', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFFBBF24))))]),
          const SizedBox(height: 12),
          Row(children: [Text('$usedSpace GB', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)), const SizedBox(width: 6), Text('/ $totalSpace GB', style: const TextStyle(fontSize: 16, color: Colors.white38))]),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: usedPercent / 100, minHeight: 6, backgroundColor: Colors.white.withOpacity(0.1), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF60A5FA)))),
        ],
      ),
    );
  }
}