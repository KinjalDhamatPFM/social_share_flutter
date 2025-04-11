// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'social_share_platform_interface.dart';

/// A web implementation of the SocialSharePlatform of the SocialShare plugin.
class SocialShareWeb extends SocialSharePlatform {
  /// Constructs a SocialShareWeb
  SocialShareWeb();

  static void registerWith(Registrar registrar) {
    SocialSharePlatform.instance = SocialShareWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  @override
  Future<void> shareToInstagram({required String imagePath, String? text, String? appId}) async {
    throw ('shareToInstagram is not supported on web');
  }

  @override
  Future<void> shareToFacebook({required String imagePath, String? text, String? appId}) async {
    throw ('shareToFacebook is not supported on web');
  }

  @override
  Future<void> shareToWhatsApp({required String text, String? imagePath}) async {
    throw ('shareToWhatsApp is not supported on web');
  }

  @override
  Future<Map<String, bool>> checkInstalledApps() async {
    throw ('checkInstalledApps is not supported on web');
  }
}
