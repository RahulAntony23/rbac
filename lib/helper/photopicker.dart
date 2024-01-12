import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  return await _picker.pickImage(source: ImageSource.gallery);
}

Future<CroppedFile?> cropImage(String path) async {
  final cropper = ImageCropper();
  return await cropper.cropImage(
    sourcePath: path,
    cropStyle: CropStyle.circle,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
  );
}
