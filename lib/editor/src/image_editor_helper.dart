import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:image/image.dart';

/// cropImageDataWithDartLibrary crop image using dart lib, no need to use native lib cause it's fast enough for us
/// https://github.com/fluttercandies/extended_image/blob/00e870cccb84380e4652a8b3c854b2967fa58733/example/lib/common/utils/crop_editor_helper.dart
Future<Uint8List> cropImageDataWithDartLibrary({
  required ExtendedImageEditorState state,
}) async {
  final Rect? cropRect = state.getCropRect();
  debugPrint('getCropRect : $cropRect');

  final Uint8List data = kIsWeb && state.widget.extendedImageState.imageWidget.image is ExtendedNetworkImageProvider
      ? await _loadNetwork(state.widget.extendedImageState.imageWidget.image as ExtendedNetworkImageProvider)
      : state.rawImageData;

  final EditActionDetails editAction = state.editAction!;

  final DateTime time1 = DateTime.now();

  //Decode source to Animation. It can holds multi frame.
  Animation? src;
  if (kIsWeb) {
    src = decodeAnimation(data);
  } else {
    src = await compute(decodeAnimation, data);
  }
  if (src != null) {
    //handle every frame.
    src.frames = src.frames.map((Image image) {
      //final DateTime time2 = DateTime.now();
      //clear orientation
      image = bakeOrientation(image);

      if (editAction.needCrop) {
        image = copyCrop(
            image, cropRect!.left.toInt(), cropRect.top.toInt(), cropRect.width.toInt(), cropRect.height.toInt());
      }

      if (editAction.needFlip) {
        late Flip mode;
        if (editAction.flipY && editAction.flipX) {
          mode = Flip.both;
        } else if (editAction.flipY) {
          mode = Flip.horizontal;
        } else if (editAction.flipX) {
          mode = Flip.vertical;
        }
        image = flip(image, mode);
      }

      if (editAction.hasRotateAngle) {
        image = copyRotate(image, editAction.rotateAngle);
      }
      //final DateTime time3 = DateTime.now();
      // debugPrint('${time3.difference(time2)} : crop/flip/rotate');
      return image;
    }).toList();
  }

  List<int>? fileData;
  //final DateTime time4 = DateTime.now();
  if (src != null) {
    final bool onlyOneFrame = src.numFrames == 1;
    //If there's only one frame, encode it to jpg.
    if (kIsWeb) {
      fileData = onlyOneFrame ? toJPEG(src.first) : encodeGifAnimation(src);
    } else {
      fileData = onlyOneFrame ? await compute(toJPEG, src.first) : await compute(encodeGifAnimation, src);
    }
  }
  final DateTime time5 = DateTime.now();
  //debugPrint('${time5.difference(time4)} : encode');
  debugPrint('${time5.difference(time1)} : crop/flip/rotate time');
  return Uint8List.fromList(fileData!);
}

List<int> toJPEG(Image image) {
  return encodeJpg(image, quality: 80);
}

/// _loadNetwork load network image, it may be failed, due to Cross-domain
Future<Uint8List> _loadNetwork(ExtendedNetworkImageProvider key) async {
  try {
    final Response? response = await HttpClientHelper.get(Uri.parse(key.url),
        headers: key.headers,
        timeLimit: key.timeLimit,
        timeRetry: key.timeRetry,
        retries: key.retries,
        cancelToken: key.cancelToken);
    return response!.bodyBytes;
  } on OperationCanceledError catch (_) {
    debugPrint('User cancel request ${key.url}.');
    return Future<Uint8List>.error(StateError('User cancel request ${key.url}.'));
  } catch (e) {
    return Future<Uint8List>.error(StateError('failed load ${key.url}. \n $e'));
  }
}
