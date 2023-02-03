import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:blurhash_dart/blurhash_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:tuple/tuple.dart';

import 'app_assets.dart';

mixin BlurHashMixinB {
  Future<Tuple2<Image, bool>> getBlurImage({
    required String cover,
    String? hash,
    required int height,
    required int width,
  }) async {
    try {
      late String imageHash;
      bool isDark = false;

      if (hash == null || hash.isEmpty) {
        final uri = Uri.parse(cover);
        final isRemoteImage = uri.isAbsolute;
        late Uint8List imageBytes;
        if (isRemoteImage) {
          imageBytes = await getBytesFromRemoteImage(uri: uri);
        } else {
          imageBytes = fileExists(cover)
              ? getBytesFromLocalImage(path: cover)
              : await getBytesFromRemoteImage(
                  uri: Uri.parse(AppAssets.coverUrl),
                );
        }

        final blurHash = blurHashImage(imageBytes: imageBytes);
        isDark = blurHash.isDark;
        imageHash = blurHash.hash;
      } else {
        imageHash = hash;
        isDark = BlurHash.decode(imageHash).isDark;
      }

      final image = imageMemory(
        hash: imageHash,
        width: width,
        height: height,
      );

      return Tuple2(image, isDark);
    } catch (e) {
      final imageBytes = getBytesFromLocalImage(path: AppAssets.placeholder);
      final blurHash = blurHashImage(imageBytes: imageBytes);
      final isDark = blurHash.isDark;
      final imageHash = blurHash.hash;

      final imagePlaceholder = imageMemory(
        hash: imageHash,
        width: width,
        height: height,
      );

      return Tuple2(imagePlaceholder, isDark);
    }
  }

  bool fileExists(String file) => io.File(file).existsSync();

  BlurHash blurHashImage({required Uint8List imageBytes}) {
    final image = img.decodeImage(imageBytes);
    final blurHash = BlurHash.encode(image!, numCompX: 4, numCompY: 3);
    return blurHash;
  }

  Image imageMemory({
    required String hash,
    required int width,
    required int height,
  }) {
    final generatedImage = BlurHash.decode(hash).toImage(width, height);
    final imageMemory = Image.memory(
      Uint8List.fromList(img.encodeJpg(generatedImage)),
    );
    return imageMemory;
  }

  Uint8List getBytesFromLocalImage({
    required String path,
  }) {
    return io.File(path).readAsBytesSync();
  }

  Future<Uint8List> getBytesFromRemoteImage({
    required Uri uri,
  }) async {
    final response = await http.get(uri);
    return response.bodyBytes;
  }

  Future<Tuple2<Image, bool>> getMediaBlurCover({
    required String? cover,
    required String? hash,
  }) async {
    final deviceSize =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    return getBlurImage(
      cover: cover ?? AppAssets.coverUrl,
      hash: hash,
      height: deviceSize.height.toInt(),
      width: deviceSize.width.toInt(),
    );
  }
}
