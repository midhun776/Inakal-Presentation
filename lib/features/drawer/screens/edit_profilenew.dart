import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
// import 'package:etutor/konstants.dart';
// import 'package:etutor/screens/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:inakal/common/controller/user_data_controller.dart';
import 'package:inakal/features/auth/controller/auth_controller.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final authController = Get.find<AuthController>();
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          if (kIsWeb)
            WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.dialog,
              size: const CropperSize(width: 520, height: 520),
            ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_croppedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    String fileName = _croppedFile!.path.split('/').last;
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://dreamthemetutor.in/api/uploadImage'));
    request.fields['userid'] = authController.userId.toString();
    request.files.add(await http.MultipartFile.fromPath(
        'file', _croppedFile!.path,
        filename: fileName));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var jsonData = jsonDecode(respStr);
      final userController = Get.find<UserDataController>();
      if (jsonData['status'] == "success") {
        userController.userData.value.user?.image = jsonData['url'];
        Navigator.pop(
          context
        );
      } else {
        _showErrorAlert(context, jsonData['message']);
      }
    } else {
      _showErrorAlert(context, 'Error uploading image');
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _showErrorAlert(BuildContext context, String message) {
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Select And Upload an Image'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _croppedFile != null || _pickedFile != null
            ? _imageCard()
            : _uploaderCard(),
      ),
    );
  }

  Widget _imageCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _image(),
          ),
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _clear,
              backgroundColor: Colors.redAccent,
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ),
            if (_croppedFile == null)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: FloatingActionButton(
                  onPressed: _cropImage,
                  backgroundColor: Colors.orange,
                  tooltip: 'Crop',
                  child: const Icon(Icons.crop),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24.0),
        if (_croppedFile != null && !_isUploading)
          ElevatedButton(
            onPressed: () => _uploadImage(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Upload Picture'),
          ),
        if (_isUploading) const CircularProgressIndicator(),
      ],
    );
  }

  Widget _image() {
    final path = _croppedFile?.path ?? _pickedFile?.path;
    if (path == null) return const SizedBox.shrink();

    return kIsWeb ? Image.network(path) : Image.file(File(path));
  }

  Widget _uploaderCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: 320.0,
        height: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DottedBorder(
                  radius: const Radius.circular(12.0),
                  borderType: BorderType.RRect,
                  dashPattern: const [8, 4],
                  color: Colors.white.withOpacity(0.4),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.image, color: Colors.white, size: 80.0),
                        SizedBox(height: 24.0),
                        Text(
                          'Upload an image to start',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text('Pick from Gallery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
