import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_result_animation.dart';

class RiveAnimationService {
  StateMachineController? _controller;
  SMIInput<bool>? _dislikeInput;
  Timer? _loopTimer;

  void dispose() {
    _loopTimer?.cancel();
    _controller?.dispose();
    _controller = null;
    _dislikeInput = null;
  }

  void initializeAnimation({
    required Artboard artboard,
    required GameResultAnimation animation,
    required bool Function() isMounted,
  }) {
    dispose();

    if (!animation.needsStateMachine) {
      return;
    }

    _controller = StateMachineController.fromArtboard(artboard, 'main');

    if (_controller != null) {
      artboard.addController(_controller!);
      _dislikeInput = _controller!.findInput<bool>('disliked');

      if (_dislikeInput != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (!isMounted() || _dislikeInput == null) return;

            _dislikeInput!.value = false;

            Future.delayed(const Duration(milliseconds: 100), () {
              if (!isMounted() || _dislikeInput == null) return;
              _dislikeInput!.value = true;
            });

            _loopTimer = Timer.periodic(const Duration(milliseconds: 2000), (
              timer,
            ) {
              if (!isMounted() || _dislikeInput == null) {
                timer.cancel();
                return;
              }
              _dislikeInput!.value = !_dislikeInput!.value;
            });
          });
        });
      }
    }
  }
}
