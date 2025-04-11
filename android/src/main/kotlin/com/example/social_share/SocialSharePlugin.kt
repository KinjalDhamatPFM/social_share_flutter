package com.example.social_share

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File


class SocialSharePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: android.content.Context? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "social_share")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("SocialSharePlugin", "Method called: ${call.method}")

        when (call.method) {

            "checkInstalledApps" -> checkInstalledApps(result)

            "shareToInstagram" -> {
                val imagePath = call.argument<String>("imagePath")
                val text = call.argument<String>("text")
                shareImageToApp("com.instagram.android", imagePath, text, result)
            }

            "shareToFacebook" -> {
                val imagePath = call.argument<String>("imagePath")
                val text = call.argument<String>("text")
                shareImageToApp("com.facebook.katana", imagePath, text, result)
            }

            "shareToWhatsApp" -> {
                val imagePath = call.argument<String>("imagePath")
                val text = call.argument<String>("text")
                shareToWhatsApp(text, imagePath, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun shareImageToApp(
        packageName: String,
        imagePath: String?,
        text: String?,
        result: MethodChannel.Result
    ) {
        if (activity == null || context == null || imagePath == null) {
            result.error("INVALID_ARGUMENTS", "Activity, context, or imagePath is null", null)
            return
        }

        val file = File(imagePath)
        if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "Image file not found at path: $imagePath", null)
            return
        }

        val imageUri: Uri = FileProvider.getUriForFile(
            context!!,
            context!!.packageName + ".fileprovider",
            file
        )

        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = "image/*"
            `package` = packageName
            putExtra(Intent.EXTRA_STREAM, imageUri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            if (!text.isNullOrEmpty()) {
                putExtra(Intent.EXTRA_TEXT, text)
            }
        }

        try {
            activity!!.startActivity(shareIntent)
            result.success(null)
        } catch (e: ActivityNotFoundException) {
            result.error("APP_NOT_FOUND", "App not installed: $packageName", null)
        }
    }

    private fun shareToWhatsApp(text: String?, imagePath: String?, result: MethodChannel.Result) {
        if (activity == null || context == null) {
            result.error("INVALID_STATE", "Activity or context is null", null)
            return
        }

        val intent = Intent(Intent.ACTION_SEND).apply {
            type = if (imagePath != null) "image/*" else "text/plain"
            setPackage("com.whatsapp")

            if (!text.isNullOrEmpty()) {
                putExtra(Intent.EXTRA_TEXT, text)
            }

            if (!imagePath.isNullOrEmpty()) {
                val file = File(imagePath)
                if (!file.exists()) {
                    result.error("FILE_NOT_FOUND", "Image file not found at path: $imagePath", null)
                    return
                }

                val uri = FileProvider.getUriForFile(
                    context!!,
                    context!!.packageName + ".fileprovider",
                    file
                )
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
        }

        try {
            activity!!.startActivity(intent)
            result.success(null)
        } catch (e: ActivityNotFoundException) {
            result.error("APP_NOT_FOUND", "WhatsApp not installed", null)
        }
    }

    fun checkInstalledApps(result: MethodChannel.Result) {
        val packageManager = activity!!.packageManager

        val apps = mapOf(
            "whatsapp" to "com.whatsapp",
            "facebook" to "com.facebook.katana",
            "instagram" to "com.instagram.android"
        )

        val installedStatus = mutableMapOf<String, Boolean>()

        for ((key, packageName) in apps) {
            try {
                packageManager.getPackageInfo(packageName, 0)
                installedStatus[key] = true
            } catch (e: PackageManager.NameNotFoundException) {
                installedStatus[key] = false
            }
        }

        result.success(installedStatus)
    }
}
