import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

import 'package:image_blurhash/blurhash_mixin_b.dart';

class MockBlurHashMixin with BlurHashMixinB {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBlurHashMixin mockBlurHashMixin;

  setUp(() {
    mockBlurHashMixin = MockBlurHashMixin();
  });

  test(
      'should return Future<Tuple2<Image, bool>> when calculateHash is called and hash is null',
      () {
    final hash = mockBlurHashMixin.getBlurImage(
      cover: 'test/utils/assets/images/rgb.png',
      height: 100,
      width: 100,
    );

    expect(hash, isA<Future<Tuple2<Image, bool>>>());
  });

  test(
      'should return Future<Tuple2<Image, bool>> when calculateHash is called and hash is not null',
      () {
    final hash = mockBlurHashMixin.getBlurImage(
      cover: 'test/utils/assets/images/rgb.png',
      hash: 'test',
      height: 100,
      width: 100,
    );

    expect(hash, isA<Future<Tuple2<Image, bool>>>());
  });

  test('should return getMediaBlurCover with cover and hash value', () async {
    final hash = await mockBlurHashMixin.getMediaBlurCover(
      cover: 'test/utils/assets/images/rgb.png',
      hash: 'test',
    );

    expect(hash, isA<Tuple2<Image, bool>>());

    expect(hash.item1, isA<Image>());
    expect(hash.item2, isA<bool>());
  });

  test('should return getBytesFromRemoteImage with uri value', () async {
    final imageBytes = await mockBlurHashMixin.getBytesFromRemoteImage(
      uri: Uri.parse('test/utils/assets/images/rgb.png'),
    );

    expect(imageBytes, isA<Uint8List>());
  });
}
