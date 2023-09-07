import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// _kPredefinedColor is the predefined color for each letter
final _kPredefinedColor = {
  'A': Colors.purple,
  'B': Colors.blue,
  'C': Colors.greenAccent,
  'D': Colors.lime,
  'E': Colors.teal,
  'F': Colors.green,
  'G': Colors.deepOrange,
  'H': Colors.orange,
  'I': Colors.orangeAccent,
  'J': Colors.yellowAccent.shade700,
  'K': Colors.red,
  'L': Colors.brown,
  'M': Colors.grey,
  'N': Colors.amber,
  'O': Colors.purpleAccent,
  'P': Colors.blueAccent,
  'Q': Colors.lightBlue,
  'R': Colors.lightBlueAccent,
  'S': Colors.deepPurple,
  'T': Colors.pinkAccent,
  'U': Colors.lightGreen,
  'V': Colors.lightGreenAccent,
  'W': Colors.deepPurpleAccent,
  'X': Colors.deepOrangeAccent,
  'Y': Colors.redAccent,
  'Z': Colors.blueGrey,
};

/// _kRadius is the radius of the avatar
const _kRadius = 20.0;

/// _kLetterCount is the default letter count of the avatar
const _kLetterCount = 2;

/// Avatar show image/letter/icon to represent user
class Avatar extends StatelessWidget {
  /// ```dart
  /// Avatar(
  ///   imageUrl:
  ///   'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ///   name: 'A'),
  /// ```
  const Avatar({
    required this.name,
    this.faceId,
    this.imageUrl,
    this.radius = _kRadius,
    super.key,
  });

  /// faceId is the face id of the avatar, it has 1~6
  final int? faceId;

  /// imageUrl is the url of the avatar image
  final String? imageUrl;

  /// name is user name
  final String name;

  /// key is the size of the avatar
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initialName = _parseNameToInitial(name, _kLetterCount).toUpperCase();
    if (imageUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        backgroundColor: Colors.transparent,
      );
    }

    if (faceId != null) {
      getFaceIcon() {
        switch (faceId) {
          case 1:
            return Icons.face_outlined;
          case 2:
            return Icons.face_2_outlined;
          case 3:
            return Icons.face_3_outlined;
          case 4:
            return Icons.face_4_outlined;
          case 5:
            return Icons.face_5_outlined;
        }
        return Icons.face_6_outlined;
      }

      return CircleAvatar(
          radius: radius,
          backgroundColor: _getFixedColor(initialName),
          foregroundColor: Colors.white,
          child: Icon(
            getFaceIcon(),
            size: 4 * (radius / 3),
          ));
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: _getFixedColor(initialName),
      foregroundColor: Colors.white,
      child: Text(
        initialName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 3 * (radius / 4),
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// _fixedColor color based on first letter
_getFixedColor(String text) {
  final char = text[0].toUpperCase();
  return _kPredefinedColor[char] ?? _kPredefinedColor.entries.elementAt(char.hashCode % 25).value;
}

/// _parseNameToInitial parse name to initial name
String _parseNameToInitial(String name, int? letterLimit) {
  // separate each word
  var parts = name.split(' ');
  var initial = '';

  // check length
  if (parts.length > 1) {
    // check max limit
    if (letterLimit != null) {
      for (var i = 0; i < letterLimit; i++) {
        // combine the first letters of each word
        initial += parts[i][0];
      }
    } else {
      // this default, if word > 1
      initial = parts[0][0] + parts[1][0];
    }
  } else {
    // this default, if word <=1
    initial = parts[0][0];
  }
  return initial;
}
