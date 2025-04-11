import 'dart:async';

import 'social_share_platform_interface.dart';

class SocialShare {
  Future<String?> getPlatformVersion() {
    return SocialSharePlatform.instance.getPlatformVersion();
  }

  /// Share to Instagram with optional [text] and required [imagePath].
  Future<void> shareToInstagram({
    required String imagePath,
    String? text,
    String? appId, // Needed for iOS
  }) async {
    return SocialSharePlatform.instance.shareToInstagram(
      imagePath: imagePath,
      text: text,
      appId: appId,
    );
  }

  /// Share to Facebook with optional [text] and required [imagePath].
  Future<void> shareToFacebook({
    required String imagePath,
    String? text,
    String? appId, // Needed for iOS
  }) async {
    return SocialSharePlatform.instance.shareToFacebook(
      imagePath: imagePath,
      text: text,
      appId: appId,
    );
  }

  /// Share to WhatsApp with [text] and optional [imagePath].
  Future<void> shareToWhatsApp({required String text, String? imagePath}) async {
    return SocialSharePlatform.instance.shareToWhatsApp(imagePath: imagePath, text: text);
  }

  /// Check if WhatsApp, Facebook, and Instagram are installed.
  Future<Map<String, bool>> checkInstalledApps() {
    return SocialSharePlatform.instance.checkInstalledApps();
  }
}

enum SocialSharePlatformType { facebook, instagram, whatsapp }

extension SocialSharePlatformTypeExtension on SocialSharePlatformType {
  String get key {
    switch (this) {
      case SocialSharePlatformType.facebook:
        return "facebook";
      case SocialSharePlatformType.instagram:
        return "instagram";
      case SocialSharePlatformType.whatsapp:
        return "whatsapp";
    }
  }
}

extension SocialShareUtils on SocialShare {
  Future<bool> isAppInstalled(SocialSharePlatformType app) async {
    final installedApps = await checkInstalledApps();
    return installedApps[app.key] ?? false;
  }
}
