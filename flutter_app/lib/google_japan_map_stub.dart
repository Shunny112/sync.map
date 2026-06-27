import 'package:flutter/material.dart';

class GoogleJapanMap extends StatelessWidget {
  const GoogleJapanMap({super.key, this.borderRadius = BorderRadius.zero});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Google map centered on Shibuya, Tokyo placeholder',
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          color: const Color(0xFF111216),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.public, color: Color(0xFF10B981), size: 34),
                SizedBox(height: 10),
                Text(
                  'Google Maps / Shibuya',
                  style: TextStyle(
                    color: Color(0xFFF6F1E8),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Chrome/Web buildで地図を表示',
                  style: TextStyle(color: Color(0xFF9B98A5), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
