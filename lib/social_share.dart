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
}
