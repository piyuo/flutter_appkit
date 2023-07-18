import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

/// _kImageMax is the max width/height of the image
const _kImageMax = 1920.0;

/// _kImageQuality is the max quality of the image
const _kImageQuality = 75;

/// _kVideoMax is the max duration of the video
const _kVideoMax = Duration(seconds: 30);

enum MediaType {
  cameraPhoto,
  cameraVideo,
  gallery,
}

/// pickMedia pick media from camera or gallery
Future<List<XFile>> pickMedia({
  MediaType mediaType = MediaType.cameraPhoto,
  double? maxWidth = _kImageMax,
  double? maxHeight = _kImageMax,
  int? imageQuality = _kImageQuality,
  bool requestFullMetadata = false,
}) async {
  List<XFile> files = [];
  final picker = ImagePicker();
  switch (mediaType) {
    case MediaType.cameraPhoto:
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (picked != null) {
        files.add(picked);
      }
      break;
    case MediaType.cameraVideo:
      final picked = await picker.pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: _kVideoMax,
      );
      if (picked != null) {
        files.add(picked);
      }
      break;
    case MediaType.gallery:
      try {
        final picked = await picker.pickMultipleMedia(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
        files.addAll(picked);
      } catch (e) {
        // pick multiple media is may fire exception on iOS when user cancel the action
        debugPrint('e');
      }
      break;
  }
  return files;
}
