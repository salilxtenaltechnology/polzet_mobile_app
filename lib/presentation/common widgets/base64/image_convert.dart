import 'dart:typed_data';
import 'dart:convert';

Uint8List? getConvertImage(image) {
  if (image == null || image.isEmpty) return null;
  try {
    String base64Data =
        image.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    return base64Decode(base64Data);
  } catch (e) {
    return null;
  }
}

Uint8List? getProfileImage(profile_picture) {
    if (profile_picture == null || profile_picture.isEmpty) return null;
    try {
      String base64Data =
          profile_picture.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      return base64Decode(base64Data);
    } catch (e) {
      return null;
    }
  }
