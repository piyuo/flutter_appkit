import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

/// insertFiles insert video or image at current index
Future<VideoPlayerController> initVideoPlayerController(XFile file) async {
  final controller = VideoPlayerController.file(File(file.path));
  await controller.initialize();
  return controller;
}
