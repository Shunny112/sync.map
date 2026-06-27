// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class GoogleJapanMap extends StatefulWidget {
  const GoogleJapanMap({super.key, this.borderRadius = BorderRadius.zero});

  final BorderRadius borderRadius;

  @override
  State<GoogleJapanMap> createState() => _GoogleJapanMapState();
}

class _GoogleJapanMapState extends State<GoogleJapanMap> {
  static const _viewType = 'sync-google-japan-map';
  static bool _registered = false;

  @override
  void initState() {
    super.initState();
    if (_registered) return;

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return html.IFrameElement()
        ..src =
            'https://www.google.com/maps?q=Shibuya,Tokyo,Japan&z=16&output=embed'
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..title = 'Google map centered on Shibuya, Tokyo'
        ..setAttribute('allowfullscreen', 'true')
        ..setAttribute('aria-label', 'Google map centered on Shibuya, Tokyo')
        ..setAttribute('loading', 'lazy')
        ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
    });
    _registered = true;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          const Positioned.fill(child: HtmlElementView(viewType: _viewType)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF08080A).withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.public, color: Color(0xFF10B981), size: 17),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Google Maps / Japan',
                      style: TextStyle(
                        color: Color(0xFFF6F1E8),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    'Live area',
                    style: TextStyle(color: Color(0xFF9B98A5), fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
