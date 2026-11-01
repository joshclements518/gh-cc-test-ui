import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Live release tips from health endpoints (not bake-time API tip).
class ReleaseTips {
  const ReleaseTips({required this.uiSha, required this.apiSha, this.error});

  final String uiSha;
  final String apiSha;
  final String? error;

  static String short(String sha) =>
      sha.length <= 12 ? sha : sha.substring(0, 12);

  String get uiShort => short(uiSha);
  String get apiShort => short(apiSha);
}

class ReleaseInfo {
  const ReleaseInfo._();

  /// Fallback if local `/healthz` is missing (e.g. `flutter run`).
  static const bakedUiSha = String.fromEnvironment('UI_SHA', defaultValue: 'unknown');

  /// Where to read the **live** API tip. Default: same-origin nginx proxy.
  /// Absolute API `/healthz` URL (set at image build). Tip SHA is read live.
  static const apiHealthUrl = String.fromEnvironment('API_HEALTH_URL', defaultValue: '');

  static Future<String?> _shaFrom(String url) async {
    final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode} for $url');
    }
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final s = (j['sha'] ?? j['apiSha'] ?? j['uiSha'])?.toString();
    if (s == null || s.isEmpty) throw StateError('no sha in $url');
    return s;
  }

  static Future<ReleaseTips> fetch() async {
    String ui = bakedUiSha;
    String api = 'unknown';
    final errors = <String>[];

    try {
      ui = (await _shaFrom('/healthz')) ?? ui;
    } catch (e) {
      if (kIsWeb) errors.add('ui: $e');
    }

    try {
      api = (await _shaFrom(apiHealthUrl)) ?? api;
    } catch (e) {
      errors.add('api: $e');
    }

    return ReleaseTips(
      uiSha: ui,
      apiSha: api,
      error: errors.isEmpty ? null : errors.join('; '),
    );
  }
}
