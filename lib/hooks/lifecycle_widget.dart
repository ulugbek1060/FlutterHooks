import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ApplicationLifecycle extends HookWidget {
  const ApplicationLifecycle({super.key});

  @override
  Widget build(BuildContext context) {
    final lifecycle = useAppLifecycleState();
    print(lifecycle);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App lifecycle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: lifecycle == AppLifecycleState.resumed ? 1.0 : 0.0,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
