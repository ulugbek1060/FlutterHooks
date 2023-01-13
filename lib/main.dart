import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SecondHomePage(),
    );
  }
}

extension CompactMap<T> on Iterable<T> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

const url =
    'https://i.pinimg.com/originals/64/85/9a/64859a369f6ee8dd53f93bd806c72af1.jpg';

class SecondHomePage extends HookWidget {
  const SecondHomePage({super.key});

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

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState('');
    useEffect(
      () {
        controller.addListener(() {
          text.value = controller.text;
        });
        return null;
      },
      // [controller],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
          ),
          Text('Yout typed: ${text.value}'),
        ],
      ),
    );
  }
}
