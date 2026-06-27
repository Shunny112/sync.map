import 'package:flutter/material.dart';

class GoogleJapanMap extends StatelessWidget {
  const GoogleJapanMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.public, color: Color(0xFF80FFD2), size: 34),
          SizedBox(height: 10),
          Text(
            'Google Maps / Japan',
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
    );
  }
}
