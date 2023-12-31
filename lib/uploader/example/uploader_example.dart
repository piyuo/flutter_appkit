// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/apollo/apollo.dart' as apollo;
import '../uploader.dart';

main() => apollo.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routes: {
        '/': (context, state, data) => const UploaderExample(),
      },
    );

class UploaderExample extends StatelessWidget {
  const UploaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    newImageUpload(_) {
      return Padding(
          padding: const EdgeInsets.all(10),
          child: ChangeNotifierProvider<ImageUploadController>(
              create: (context) => ImageUploadController(
                    uploader: Uploader(
                      filenames: [
//                'iphone-card-40-iphone13problue-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948813000',
                      ],
                      imageUploader: (bytes, deleteFilename) async {
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
              })));
    }

    changeImageUpload(_) {
      return ChangeNotifierProvider<ImageUploadController>(
          create: (context) => ImageUploadController(
                uploader: Uploader(
                  filenames: [
                    'iphone-card-40-iphone13problue-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948813000',
                  ],
                  imageUploader: (bytes, deleteFilename) async {
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

    editImage(_) {
      return ChangeNotifierProvider<ImageUploadEditor>(
          create: (context) => ImageUploadEditor(
                uploader: Uploader(
                  filenames: [],
                  imageUploader: (bytes, deleteFilename) async {
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

    return testing.ExampleScaffold(
      builder: newImageUpload,
      buttons: [
        testing.ExampleButton('new image upload', builder: newImageUpload),
        testing.ExampleButton('change image upload', builder: changeImageUpload),
        testing.ExampleButton('edit image', builder: editImage),
      ],
    );
  }
}
