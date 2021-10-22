// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'uploader.dart';
import 'image_upload.dart';
import 'image_upload_controller.dart';
import 'image_upload_editor.dart';

class UploaderPlayground extends StatelessWidget {
  const UploaderPlayground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                child: _editImage(),
              ),
              testing.example(
                context,
                text: 'new image upload',
                child: _newImageUpload(),
              ),
              testing.example(
                context,
                text: 'change image upload',
                child: _changeImageUpload(),
              ),
              testing.example(
                context,
                text: 'edit image',
                child: _editImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newImageUpload() {
    return ChangeNotifierProvider<ImageUploadController>(
        create: (context) => ImageUploadController(
              uploader: Uploader(
                filenames: [
//                'iphone-card-40-iphone13problue-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948813000',
                ],
                uploadFunc: (context, bytes, deleteFilename) async {
                  await Future.delayed(const Duration(seconds: 2));
                  return 'iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';
                },
              ),
            ),
        child: Consumer<ImageUploadController>(builder: (context, controller, child) {
          return ImageUpload(
            imageRoot: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/',
            controller: controller,
            description: 'recommend size:1280x1280, support gif, jpeg, png',
          );
        }));
  }

  Widget _changeImageUpload() {
    return ChangeNotifierProvider<ImageUploadController>(
        create: (context) => ImageUploadController(
              uploader: Uploader(
                filenames: [
                  'iphone-card-40-iphone13problue-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948813000',
                ],
                uploadFunc: (context, bytes, deleteFilename) async {
                  await Future.delayed(const Duration(seconds: 2));
                  return 'iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';
                },
              ),
            ),
        child: Consumer<ImageUploadController>(builder: (context, controller, child) {
          return ImageUpload(
            imageRoot: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/',
            controller: controller,
            description: 'recommend size:1280x1280, support gif, jpeg, png',
          );
        }));
  }

  Widget _editImage() {
    return ChangeNotifierProvider<ImageUploadEditor>(
        create: (context) => ImageUploadEditor(
              uploader: Uploader(
                filenames: [],
                uploadFunc: (context, bytes, deleteFilename) async {
                  await Future.delayed(const Duration(seconds: 2));
                  return 'iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';
                },
              ),
            ),
        child: Consumer<ImageUploadEditor>(builder: (context, controller, child) {
          return ImageUpload(
            imageRoot: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/',
            controller: controller,
            description: 'recommend size:1280x1280, support gif, jpeg, png',
          );
        }));
  }
}
