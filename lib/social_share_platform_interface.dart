import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_share_method_channel.dart';

abstract class SocialSharePlatform extends PlatformInterface {
  SocialSharePlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialSharePlatform _instance = MethodChannelSocialShare();

  static SocialSharePlatform get instance => _instance;

  static set instance(SocialSharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> shareToInstagram({required String imagePath, String? text, String? appId}) {
    throw UnimplementedError('shareToInstagram() has not been implemented.');
  }

  Future<void> shareToFacebook({required String imagePath, String? text, String? appId}) {
    throw UnimplementedError('shareToFacebook() has not been implemented.');
  }

  Future<void> shareToWhatsApp({required String text, String? imagePath}) {
    throw UnimplementedError('shareToWhatsApp() has not been implemented.');
  }
}
