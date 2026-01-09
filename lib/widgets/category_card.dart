import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String size;
  final String count;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.icon, required this.title, required this.subtitle, required this.size, required this.count, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0A0A0A), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)))])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(size, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)), const SizedBox(height: 2), Text(count, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3)))]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}