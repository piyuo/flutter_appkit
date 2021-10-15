// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/custom.dart' as custom;
import 'uploader.dart';
import 'single_image_uploader.dart';

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
                child: _singleImageUploader(),
              ),
              custom.example(
                context,
                text: 'single image uploader',
                child: _singleImageUploader(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _singleImageUploader() {
    return ChangeNotifierProvider<Uploader>(
        create: (context) => Uploader(
              filenames: [
//                'iphone-card-40-iphone13problue-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948813000',
              ],
              uploadFunc: (context, bytes, deleteFilename) async {
                await Future.delayed(const Duration(seconds: 2));
                return 'iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';
              },
            ),
        child: Consumer<Uploader>(builder: (context, uploader, child) {
          return SingleImageUploader(
            imageRoot: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/',
            uploader: uploader,
            description: 'recommend size:1024x1024, support jpg, jpeg, png, webp',
          );
        }));
  }
}
