import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'social_share_platform_interface.dart';

/// An implementation of [SocialSharePlatform] that uses method channels.
class MethodChannelSocialShare extends SocialSharePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_share');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> shareToInstagram({required String imagePath, String? text, String? appId}) async {
    await methodChannel.invokeMethod('shareToInstagram', {
      'imagePath': imagePath,
      if (text != null) 'text': text,
      if (appId != null) 'appId': appId,
    });
  }

  @override
  Future<void> shareToFacebook({required String imagePath, String? text, String? appId}) async {
    await methodChannel.invokeMethod('shareToFacebook', {
      'imagePath': imagePath,
      if (text != null) 'text': text,
      if (appId != null) 'appId': appId,
    });
  }

  @override
  Future<void> shareToWhatsApp({required String text, String? imagePath}) async {
    await methodChannel.invokeMethod('shareToWhatsApp', {
      'text': text,
      if (imagePath != null) 'imagePath': imagePath,
    });
  }

  @override
  Future<Map<String, bool>> checkInstalledApps() async {
    final result = await methodChannel.invokeMethod<Map>('checkInstalledApps');
    return Map<String, bool>.from(result ?? {});
  }
}
