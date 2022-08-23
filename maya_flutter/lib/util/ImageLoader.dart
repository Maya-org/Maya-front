import 'package:flutter/widgets.dart';

class ImageLoader {
  /// Show an image from a local asset. or if the asset is not found, throwing an flutter error.
  static Image loadFromAsset(String key) {
    return Image(image: AssetImage(key));
  }
}
