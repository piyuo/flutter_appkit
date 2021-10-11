import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:libcli/delta.dart' as delta;
import 'uploader.dart';
import 'single_image_uploader_provider.dart';
import 'l10n.dart';

class SingleImageUploader extends StatelessWidget {
  const SingleImageUploader({
    required this.uploader,
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

  /// uploader to upload file
  final Uploader uploader;

  /// description can show description on bottom of image  uploader
  final String? description;

  /// _buildDropzone create a dropzone to support browser drop file
  Widget _buildDropzone(
    BuildContext context, {
    required SingleImageProvider provide,
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
            mime: uploader.acceptMIME,
            operation: DragOperation.copy,
            onCreated: (DropzoneViewController ctrl) => provide.setDropController(ctrl),
            onError: (String? ev) => provide.error(context, ev),
            onDrop: (dynamic ev) async => await provide.dropImage(context, ev),
            onHover: () => provide.setDragging(context, true),
            onLeave: () => provide.setDragging(context, false),
          ),
        ),
        child,
        if (provide.dragging) _buildDragging(context, provide),
        if (provide.dragging)
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
                        child: Text('drop'.l10n,
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
    required SingleImageProvider provide,
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
        boxShadow: provide.dragging
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
        strokeWidth: provide.dragging ? 0 : 4,
        borderType: BorderType.RRect,
        dashPattern: const <double>[15, 10],
        radius: const Radius.circular(20),
        padding: const EdgeInsets.all(20),
        child: SizedBox.expand(child: child),
      ),
    );
  }

  /// _buildBusy create a busy loading icon
  Widget _buildBusy(BuildContext context, SingleImageProvider provide) {
    return _buildCard(context,
        color: context.themeColor(
          light: Colors.grey[200]!,
          dark: Colors.grey[800]!,
        ),
        provide: provide,
        child: const Padding(
            padding: EdgeInsets.all(0),
            child: CircularProgressIndicator(
              value: null,
              strokeWidth: 10.0,
              color: Colors.grey,
            )));
  }

  /// _buildDragging create dragging icon
  Widget _buildDragging(BuildContext context, SingleImageProvider provide) {
    return _buildCard(
      context,
      color: Colors.blue[400]!,
      provide: provide,
      child: const Icon(
        Icons.add,
        size: 128,
        color: Colors.white,
      ),
    );
  }

  /// _buildChangeUpload create a uploader ui to change image
  Widget _buildChangeUpload(BuildContext context, SingleImageProvider provide) {
    return SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: delta.WebImage(
                imageRoot + provide.firstFile!,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: FloatingActionButton(
                child: const Icon(Icons.file_upload_rounded, size: 42),
                //padding: EdgeInsets.zero,
                tooltip: 'upload'.l10n,
                onPressed: () => provide.pickImage(context),
              ),
            ),
          ],
        ));
  }

  /// _buildNewUpload create a uploader ui to upload new image
  Widget _buildNewUpload(BuildContext context, SingleImageProvider provide) {
    final iconColor = provide.dragging ? Colors.white : Colors.grey[400];
    return _buildCard(context,
        color: context.themeColor(
          light: Colors.grey[200]!,
          dark: Colors.grey[800]!,
        ),
        provide: provide,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () => provide.pickImage(context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(
                    provide.dragging ? Icons.add : Icons.file_upload_rounded,
                    size: 52,
                    color: iconColor,
                  ),
                )),
            if (!provide.dragging)
              InkWell(
                  onTap: () => provide.pickImage(context),
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'dropImg'.l10n,
                        style: TextStyle(
                          color: context.themeColor(light: Colors.grey[600]!, dark: Colors.grey[400]!),
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: 'tap'.l10n,
                        style: TextStyle(
                          color: Colors.blue[600]!,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ))),
            if (!provide.dragging) const SizedBox(height: 10),
            if (!provide.dragging && description != null)
              Text(
                description!,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleImageProvider>(
        create: (context) => SingleImageProvider(
              uploader: uploader,
            ),
        child: Consumer<SingleImageProvider>(builder: (context, provide, child) {
          if (provide.busy) {
            return _buildBusy(context, provide);
          }
          final child = provide.dragging
              ? const SizedBox()
              : provide.isEmpty
                  ? _buildNewUpload(context, provide)
                  : _buildChangeUpload(context, provide);
          return SizedBox(
            width: width,
            height: height,
            child: kIsWeb
                ? _buildDropzone(
                    context,
                    provide: provide,
                    child: child,
                  )
                : child,
          );
        }));
  }
}
