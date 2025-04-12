#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint social_share.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'social_share'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for sharing content.'
  s.description      = <<-DESC
A plugin to share content to apps like Instagram, Facebook, and WhatsApp.
                       DESC
  s.homepage         = 'https://github.com/KinjalDhamatPFM/social_share_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kinjal Dhamat' => 'your@email.com' }

  s.source           = { :git => 'https://github.com/KinjalDhamatPFM/social_share_flutter.git' }

  s.source_files     = 'Classes/**/*'
  s.module_name      = 'social_share'
  s.dependency       'Flutter'
  s.static_framework = true
  s.swift_version    = '5.0'
  s.platform         = :ios, '11.0'
end
