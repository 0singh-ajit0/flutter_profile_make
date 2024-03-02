import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List?> pickImage(ImageSource src) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: src);
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

Future<File> getImageFromAssets(String path) async {
  final byteData = await rootBundle.load("assets/$path");
  final file = File("${(await getTemporaryDirectory()).path}/$path");
  await file.create(recursive: true);
  await file.writeAsBytes(
    byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ),
  );
  return file;
}
