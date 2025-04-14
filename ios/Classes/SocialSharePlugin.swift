import Flutter
import UIKit

public class SocialSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_share", binaryMessenger: registrar.messenger())
    let instance = SocialSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkInstalledApps":
      checkInstalledApps(result: result)

    case "shareToInstagram":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      let imagePath = args["imagePath"] as? String
      let text = args["text"] as? String
      let appId = args["appId"] as? String
      shareToInstagram(imagePath: imagePath, text: text, appId: appId, result: result)

    case "shareToFacebook":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      let imagePath = args["imagePath"] as? String
      let text = args["text"] as? String
      let appId = args["appId"] as? String
      shareToFacebook(imagePath: imagePath, text: text, appId: appId, result: result)

    case "shareToWhatsApp":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      let text = args["text"] as? String ?? ""
      let imagePath = args["imagePath"] as? String
      shareToWhatsApp(text: text, imagePath: imagePath, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func shareToInstagram(imagePath: String?, text: String?, appId: String?, result: @escaping FlutterResult) {
      guard let path = imagePath,
            let appId = appId else {
          result(FlutterError(code: "INVALID_DATA", message: "Image path or App ID missing", details: nil))
          return
      }

      let urlScheme = URL(string: "instagram-stories://share?source_application=\(appId)")!

      guard UIApplication.shared.canOpenURL(urlScheme) else {
          result(FlutterError(code: "APP_NOT_INSTALLED", message: "Instagram not installed", details: nil))
          return
      }

      let fileManager = FileManager.default
      let imageURL = URL(fileURLWithPath: path)
      guard fileManager.fileExists(atPath: imageURL.path) else {
          result(FlutterError(code: "FILE_NOT_FOUND", message: "Image file not found at path", details: nil))
          return
      }

      do {
          let imageData = try Data(contentsOf: imageURL)
          var pasteboardItems: [String: Any] = [
              "com.instagram.sharedSticker.stickerImage": imageData,
              "com.instagram.sharedSticker.appID": appId,
          ]

          if let contentUrl = text {
              pasteboardItems["com.instagram.sharedSticker.contentURL"] = contentUrl
          }

          let pasteboardOptions = [
              UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
          ]

          UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
          UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
          result(nil)
      } catch {
          result(FlutterError(code: "DATA_ERROR", message: "Failed to load image data: \(error.localizedDescription)", details: nil))
      }
  }


  private func shareToFacebook(imagePath: String?, text: String?, appId: String?, result: @escaping FlutterResult) {
    guard let path = imagePath,
          let image = UIImage(contentsOfFile: path),
          let appId = appId else {
      result(FlutterError(code: "INVALID_DATA", message: "Image path or App ID missing", details: nil))
      return
    }

    guard let urlScheme = URL(string: "facebook-stories://share") else {
      result(FlutterError(code: "SCHEME_ERROR", message: "Cannot form Facebook URL scheme", details: nil))
      return
    }

    if UIApplication.shared.canOpenURL(urlScheme) {
      guard let imageData = image.pngData() else {
        result(FlutterError(code: "DATA_ERROR", message: "Image data invalid", details: nil))
        return
      }

      let pasteboardItems: [String: Any] = [
        "com.facebook.sharedSticker.backgroundImage": imageData,
        "com.facebook.sharedSticker.contentURL": text ?? "",
        "com.facebook.sharedSticker.appID": appId
      ]

      let pasteboardOptions = [
        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
      ]

      UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
      UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
      result(nil)
    } else {
      result(FlutterError(code: "APP_NOT_INSTALLED", message: "Facebook not installed", details: nil))
    }
  }

  private func shareToWhatsApp(text: String, imagePath: String?, result: @escaping FlutterResult) {
    let urlString = "whatsapp://send?text=\(text)"

    if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
       let whatsappURL = URL(string: encodedURLString),
       UIApplication.shared.canOpenURL(whatsappURL) {

      UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
      result("success")

    } else {
      result(FlutterError(code: "APP_NOT_AVAILABLE", message: "WhatsApp not available", details: nil))
    }
  }

  private func checkInstalledApps(result: @escaping FlutterResult) {
   let apps = [
       "instagram": "instagram-stories://",
       "facebook": "facebook-stories://",
       "whatsapp": "whatsapp://"
            ]

     var installedStatus: [String: Bool] = [:]

     for (key, scheme) in apps {
       if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
         installedStatus[key] = true
       } else {
         installedStatus[key] = false
       }
     }

     result(installedStatus)
  }
}
