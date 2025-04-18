import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_share/social_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ShareExampleScreen());
  }
}

class ShareExampleScreen extends StatefulWidget {
  const ShareExampleScreen({super.key});

  @override
  State<ShareExampleScreen> createState() => _ShareExampleScreenState();
}

class _ShareExampleScreenState extends State<ShareExampleScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  final SocialShare socialSharePlugin = SocialShare();
  String appId = "392982542324341";

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _shareToInstagram() async {
    if (_imageFile == null) return;
    debugPrint("Sharing to Instagram with image: ${_imageFile!.path}");
    await socialSharePlugin.shareToInstagram(
      imagePath: _imageFile!.path,
      text: "Check this out on Instagram!",
      appId: appId,
    );
  }

  Future<void> _shareToFacebook() async {
    if (_imageFile == null) return;
    await socialSharePlugin.shareToFacebook(
      imagePath: _imageFile!.path,
      text: "Sharing to Facebook with an image!",
      appId: appId,
    );
  }

  Future<void> _shareToWhatsApp() async {
    if (_imageFile == null) return;
    await socialSharePlugin.shareToWhatsApp(
      text: "Hello from Flutter!",
      imagePath: _imageFile!.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Share Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            if (_imageFile != null) Image.file(_imageFile!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _shareToInstagram, child: const Text('Share to Instagram')),
            ElevatedButton(onPressed: _shareToFacebook, child: const Text('Share to Facebook')),
            ElevatedButton(onPressed: _shareToWhatsApp, child: const Text('Share to WhatsApp')),
          ],
        ),
      ),
    );
  }
}
