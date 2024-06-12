import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<Uint8List> imageToBytes(String imagePath, {int width = 100}) async {
  final byData = await rootBundle.load(imagePath);
  final bytes = byData.buffer.asUint8List();
  final ui.Codec codec =
      await ui.instantiateImageCodec(bytes, targetWidth: width);
  final frame = await codec.getNextFrame();
  final newByData =
      await frame.image.toByteData(format: ui.ImageByteFormat.png);

  return newByData!.buffer.asUint8List();
}
