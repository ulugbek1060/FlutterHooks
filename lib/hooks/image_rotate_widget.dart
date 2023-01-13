import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_example/hooks/image_widget.dart';

class ImageRotateWidget extends HookWidget {
  const ImageRotateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(onListen: (() {
      controller.sink.add(0.0);
    }));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image roatation'),
      ),
      body: StreamBuilder<double>(
        stream: controller.stream,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final rotation = snapshot.data ?? 0.0;
          return GestureDetector(
            onTap: () {
              controller.sink.add(rotation + 10.0);
            },
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(rotation / 360.0),
              child: Center(
                child: Image.network(url),
              ),
            ),
          );
        }),
      ),
    );
  }
}

enum Actions { rotateLeft, rotateRight, increaseAlpha, decreaseAlpha }

class State {
  final double rotateDeg;
  final double alpha;

  const State({
    required this.rotateDeg,
    required this.alpha,
  });

  const State.zero()
      : alpha = 1.0,
        rotateDeg = 0.0;

  State rotateLeft() => State(
        rotateDeg: rotateDeg - 10.0,
        alpha: alpha,
      );

  State rotateRight() => State(
        rotateDeg: rotateDeg + 10.0,
        alpha: alpha,
      );

  State increaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: min(alpha + 0.1, 1.0),
      );

  State decreaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Actions? action) {
  switch (action) {
    case Actions.rotateLeft:
      return oldState.rotateLeft();
    case Actions.rotateRight:
      return oldState.rotateRight();
    case Actions.increaseAlpha:
      return oldState.increaseAlpha();
    case Actions.decreaseAlpha:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class ImageEditingWidget extends HookWidget {
  const ImageEditingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Actions?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image editor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    store.dispatch(Actions.rotateRight);
                  },
                  child: const Text('Rotate Right'),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(Actions.rotateLeft);
                  },
                  child: const Text('Rotate Left'),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(Actions.increaseAlpha);
                  },
                  child: const Text('+ Alpha'),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(Actions.decreaseAlpha);
                  },
                  child: const Text('- Alpha'),
                )
              ],
            ),
            Opacity(
              opacity: store.state.alpha,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(
                  store.state.rotateDeg / 360.0,
                ),
                child: Image.network(url),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
