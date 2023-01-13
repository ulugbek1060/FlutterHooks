import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const url =
    'https://i.pinimg.com/originals/64/85/9a/64859a369f6ee8dd53f93bd806c72af1.jpg';

extension CompactMap<T> on Iterable<T> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

class ImageWidget extends HookWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('run...');
    final image = useMemoized(() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((value) => value.buffer.asUint8List())
        .then((value) => Image.memory(value)));

    final snapshot = useFuture(image);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Image>[snapshot.data!].compactMap().toList(),
        ),
      ),
    );
  }
}
