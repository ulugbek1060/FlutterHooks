import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_example/hooks/image_widget.dart';

extension Normalization on num {
  num normalized(
    num selfRangeMin,
    num selfRangeMax, [
    num normalizedRangeMin = 0.0,
    num normalizedRangeMax = 1.0,
  ]) =>
      (normalizedRangeMax - normalizedRangeMin) *
          ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) +
      normalizedRangeMin;
}

class SliverWidget extends HookWidget {
  const SliverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final animatedOpasity = useAnimationController(
      duration: const Duration(seconds: 1),
      initialValue: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    final animatedSize = useAnimationController(
      duration: const Duration(seconds: 1),
      initialValue: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    final scrollController = useScrollController();
    useEffect(
      () {
        scrollController.addListener(() {
          final newOpasity = max(300.0 - scrollController.offset, 0.0);
          final normalized = newOpasity.normalized(0.0, 300.0).toDouble();
          animatedOpasity.value = normalized;
          animatedSize.value = normalized;
        });
        return null;
      },
      [scrollController],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          SizeTransition(
            sizeFactor: animatedSize,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: animatedOpasity,
              child: Image.network(
                url,
                height: 300.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(
                title: Text('Person ${index + 1}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
