import 'package:flutter/material.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/apollo/apollo.dart' as apollo;

/// _kBorderRadius is the border radius for embed
const _kBorderRadius = BorderRadius.all(Radius.circular(12));

/// _kEmojiSize is a emoji size
const _kEmojiSize = 28.0;

/// UrlBuilder return the url of the image base on word type and id
typedef UrlBuilder = String Function(net.Word_WordType type, String id);

/// MessageView is a widget that display message
class MessageView extends StatelessWidget {
  const MessageView({
    required this.words,
    required this.urlBuilder,
    this.textStyle,
    this.maxMediaHeight = 320,
    super.key,
  });

  /// words is a list of words that will be display
  final List<net.Word> words;

  /// textStyle for message
  final TextStyle? textStyle;

  /// urlBuilder return the url of the image base on word type and id
  final String Function(String id) urlBuilder;

  /// _isSingleMedia return true if words is a single media
  bool get _isSingleMedia => isSingleMedia(words);

  /// maxMediaHeight is the max height of media
  final double maxMediaHeight;

  @override
  Widget build(BuildContext context) {
    buildMedia(Widget child, Size? size) {
      Widget result = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxMediaHeight),
          child: (size != null && size.width > 0 && size.height > 0)
              ? AspectRatio(aspectRatio: size.width / size.height, child: child)
              : child);
      if (!_isSingleMedia) {
        result = Align(child: result);
      }
      return result;
    }

    return Wrap(
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: words.map((word) {
        switch (word.type) {
          case net.Word_WordType.WORD_TYPE_TEXT:
            return Text(word.value, style: textStyle);
          case net.Word_WordType.WORD_TYPE_EMOJI:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(word.value, style: const TextStyle(fontSize: _kEmojiSize)),
            );
          case net.Word_WordType.WORD_TYPE_IMAGE:
            return buildMedia(
              apollo.PreviewImage(
                urlBuilder(word.value),
                borderRadius: _isSingleMedia ? null : _kBorderRadius,
              ),
              Size(word.width.toDouble(), word.height.toDouble()),
            );
          case net.Word_WordType.WORD_TYPE_VIDEO:
            return buildMedia(
              apollo.PreviewVideo(
                urlBuilder(word.value),
                borderRadius: _isSingleMedia ? null : _kBorderRadius,
                height: 240,
              ),
              Size(word.width.toDouble(), word.height.toDouble()),
            );

          default:
        }
        return const SizedBox();
      }).toList(),
    );
  }
}

/// isSingleMedia return true if words is a single media
bool isSingleMedia(List<net.Word> words) {
  return words.length == 1 &&
      (words[0].type == net.Word_WordType.WORD_TYPE_IMAGE || words[0].type == net.Word_WordType.WORD_TYPE_VIDEO);
}
