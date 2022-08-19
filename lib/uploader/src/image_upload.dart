import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'image_upload_controller.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({
    required this.controller,
    required this.imageRoot,
    this.width = 240,
    this.height = 240,
    this.description,
    Key? key,
  }) : super(key: key);

  /// imageRoot image url root path like 'https://customer1.piyuo.com/a'
  final String imageRoot;

  /// width is image uploader width
  final double width;

  /// width is image uploader height
  final double height;

  /// controller control pick or dropped image and upload to cloud
  final ImageUploadController controller;

  /// description can show description on bottom of image  uploader
  final String? description;

  /// _buildDropzone create a dropzone to support browser drop file
  Widget _buildDropzone(
    BuildContext context, {
    required Widget child,
  }) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          height: mediaQuerySize.height,
          width: mediaQuerySize.width,
          child: DropzoneView(
            mime: controller.uploader.acceptMIME,
            operation: DragOperation.copy,
            onCreated: (DropzoneViewController ctrl) => controller.setDropController(ctrl),
            onError: (String? ev) {
              if (ev != null) dialog.alert(ev);
            },
            onDrop: (dynamic ev) async => await controller.dropImage(context, ev),
            onHover: () => controller.setDragging(context, true),
            onLeave: () => controller.setDragging(context, false),
          ),
        ),
        child,
        if (controller.dragging) _buildDragging(context),
        if (controller.dragging)
          Positioned(
              left: 0,
              top: 0,
              height: mediaQuerySize.height,
              width: mediaQuerySize.width,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: DottedBorder(
                  color: Colors.black12,
                  strokeWidth: 10,
                  borderType: BorderType.RRect,
                  dashPattern: const <double>[10, 5],
                  radius: const Radius.circular(25),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(context.i18n.uploadDrop,
                            style: const TextStyle(
                              fontSize: 64,
                              color: Colors.black38,
                            )),
                      )),
                ),
              )),
      ],
    );
  }

  /// _buildCard build a uploader card
  Widget _buildCard(
    BuildContext context, {
    required Widget child,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: color,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: controller.dragging
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(3, 3), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: DottedBorder(
        color: Colors.black12,
        strokeWidth: controller.dragging ? 0 : 4,
        borderType: BorderType.RRect,
        dashPattern: const <double>[15, 10],
        radius: const Radius.circular(20),
        padding: const EdgeInsets.all(20),
        child: SizedBox.expand(child: child),
      ),
    );
  }

  /// _buildBusy create a busy loading icon
  Widget _buildBusy(BuildContext context) {
    return _buildCard(context,
        color: context.themeColor(
          light: Colors.grey.shade200,
          dark: Colors.grey.shade800,
        ),
        child: const Padding(
            padding: EdgeInsets.all(0),
            child: CircularProgressIndicator(
              value: null,
              strokeWidth: 10.0,
              color: Colors.grey,
            )));
  }

  /// _buildDragging create dragging icon
  Widget _buildDragging(BuildContext context) {
    return _buildCard(
      context,
      color: Colors.blue.shade400,
      child: const Icon(
        Icons.add,
        size: 128,
        color: Colors.white,
      ),
    );
  }

  /// _buildChangeUpload create a uploader ui to change image
  Widget _buildChangeUpload(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: delta.WebImage(
                imageRoot + controller.firstFile!,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: FloatingActionButton(
                tooltip: context.i18n.uploadButtonText,
                onPressed: () => controller.pickImage(context),
                child: const Icon(Icons.file_upload_rounded, size: 42),
              ),
            ),
          ],
        ));
  }

  /// _buildNewUpload create a uploader ui to upload new image
  Widget _buildNewUpload(BuildContext context) {
    final iconColor = controller.dragging ? Colors.white : Colors.grey[400];
    return _buildCard(context,
        color: context.themeColor(
          light: Colors.grey.shade200,
          dark: Colors.grey.shade800,
        ),
        child: delta.Mounted(
            builder: (context, isMounted) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          final file = await controller.pickImage(context);
                          final mounted = isMounted();
                          if (file != null && mounted) {
                            await controller.upload(context, file);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Icon(
                            controller.dragging ? Icons.add : Icons.file_upload_rounded,
                            size: 52,
                            color: iconColor,
                          ),
                        )),
                    if (!controller.dragging)
                      InkWell(
                          onTap: () async {
                            final file = await controller.pickImage(context);
                            final mounted = isMounted();
                            if (file != null && mounted) {
                              await controller.upload(context, file);
                            }
                          },
                          child: RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: context.i18n.uploadDrop,
                                style: TextStyle(
                                  color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: context.i18n.uploadBrowse,
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ))),
                    if (!controller.dragging) const SizedBox(height: 10),
                    if (!controller.dragging && description != null)
                      Text(
                        description!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (controller.busy) {
      return _buildBusy(context);
    }
    final child = controller.dragging
        ? const SizedBox()
        : controller.isEmpty
            ? _buildNewUpload(context)
            : _buildChangeUpload(context);
    return SizedBox(
      width: width,
      height: height,
      child: kIsWeb
          ? _buildDropzone(
              context,
              child: child,
            )
          : child,
    );
  }
}
