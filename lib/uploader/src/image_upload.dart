import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    /// buildCard build a uploader card
    Widget buildCard({
      required Widget child,
      required Color color,
    }) {
      return SizedBox(
        width: width,
        height: height,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox.expand(child: child),
          ),
        ),
      );
    }

    /// buildDragging create dragging icon
    Widget buildDragging() {
      return buildCard(
        color: colorScheme.primary,
        child: Icon(
          Icons.add,
          size: 128,
          color: colorScheme.onPrimary,
        ),
      );
    }

    /// buildDropzone create a dropzone to support browser drop file
    Widget buildDropzone(Widget child) {
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
          if (controller.dragging) buildDragging(),
          if (controller.dragging)
            Positioned(
                left: 0,
                top: 0,
                height: mediaQuerySize.height,
                width: mediaQuerySize.width,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: DottedDecoration(
                    shape: Shape.box,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(context.i18n.uploadDrop,
                            style: TextStyle(
                              fontSize: 32,
                              color: colorScheme.onBackground,
                            )),
                      )),
                )),
        ],
      );
    }

    /// buildBusy create a busy loading icon
    Widget buildBusy() {
      return buildCard(
          color: colorScheme.secondaryContainer,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 10.0,
                color: colorScheme.onSecondaryContainer,
              )));
    }

    /// buildChangeUpload create a uploader ui to change image
    Widget buildChangeUpload() {
      return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: delta.WebImage(
                  url: imageRoot + controller.firstFile!,
                  width: width,
                  height: height,
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

    /// buildNewUpload create a uploader ui to upload new image
    Widget buildNewUpload() {
      final foregroundColor = controller.dragging ? colorScheme.onTertiaryContainer : colorScheme.onPrimaryContainer;
      return buildCard(
          color: colorScheme.primaryContainer,
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
                              color: foregroundColor,
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
                            splashColor: colorScheme.primaryContainer,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: RichText(
                                text: TextSpan(
                              children: [
                                TextSpan(
                                  text: context.i18n.uploadDrop,
                                  style: TextStyle(
                                    color: foregroundColor,
                                  ),
                                ),
                                TextSpan(
                                  text: context.i18n.uploadBrowse,
                                  style: TextStyle(
                                    color: foregroundColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ))),
                      if (!controller.dragging) const SizedBox(height: 10),
                      if (!controller.dragging && description != null)
                        Text(
                          description!,
                          style: TextStyle(color: foregroundColor.withOpacity(.8)),
                        ),
                    ],
                  )));
    }

    if (controller.busy) {
      return buildBusy();
    }
    final child = controller.dragging
        ? const SizedBox()
        : controller.isEmpty
            ? buildNewUpload()
            : buildChangeUpload();
    return SizedBox(
      width: width,
      height: height,
      child: kIsWeb ? buildDropzone(child) : child,
    );
  }
}
