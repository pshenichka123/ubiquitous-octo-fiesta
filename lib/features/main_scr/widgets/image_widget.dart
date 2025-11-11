import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // ← Новый импорт
import 'dart:typed_data';

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key});

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  File? _image;
  Uint8List? _imageBytes; // ← Кэшируем байты!
  final ImagePicker _picker = ImagePicker();
  static const String _imageFileName = 'profile_photo.jpg';

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_imageFileName');

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _image = file;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_imageFileName');
    await image.copy(file.path);

    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _image = file;
      _imageBytes = bytes;
    });
  }

  Future<void> _pickAndCropImage() async {
    var status = await Permission.photos.request();
    if (!status.isGranted) return;

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile == null) return;

    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.square,
          hideBottomControls: true,
          lockAspectRatio: true,
          showCropGrid: false,
          cropFrameColor: Colors.blue,
          // aspectRatioPresets теперь ТУТ:
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(aspectRatioPresets: [CropAspectRatioPreset.square]),
      ],
    );

    if (cropped != null) {
      final File finalImage = File(cropped.path);
      await _saveImage(finalImage); // твоя функция сохранения
      _showSnackBar('Фото обрезано и сохранено!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _imageBytes == null
              ? const Center(
                  child: Text(
                    'Фото не выбрано',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!, // ← Используем кэшированные байты
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        TextButton.icon(
          onPressed: _pickAndCropImage,
          icon: const Icon(Icons.photo_library),
          label: const Text('Загрузить фото'),
        ),
      ],
    );
  }
}
