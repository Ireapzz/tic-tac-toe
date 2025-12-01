import 'dart:async';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/domain/services/minimax_ai.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_mode_controller.dart';
import 'package:tic_tac_toe/core/utils/haptic_feedback.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_controller.g.dart';

@Riverpod()
class GameController extends _$GameController {
  final _minimaxAI = MinimaxAI();
  Timer? _aiTimer;

  @override
  GameModel build() {
    ref.onDispose(() {
      _aiTimer?.cancel();
    });
    return GameModel.initial();
  }

  bool get isGameOver => state.isGameOver;

  void playerMove(int index) {
    if (!_canPlayMove(index)) {
      HapticFeedbackHelper.playError();
      return;
    }

    _executeMove(index);

    final gameMode = ref.read(gameModeControllerProvider);
    if (gameMode == GameMode.vsComputer && !state.isGameOver) {
      _scheduleAIMove();
    }
  }

  void _playAIMove() {
    if (state.isGameOver || state.currentPlayer != Player.o) {
      return;
    }

    final moveCalculated = _minimaxAI.getBestMove(state);
    _executeMove(moveCalculated);
  }

  void _scheduleAIMove() {
    _aiTimer?.cancel();
    _aiTimer = Timer(const Duration(milliseconds: 500), () {
      if (!state.isGameOver && state.currentPlayer == Player.o) {
        _playAIMove();
      }
    });
  }

  bool _canPlayMove(int index) {
    return !state.isGameOver && state.board[index] == null;
  }

  void _executeMove(int index) {
    state = state.playMove(index);
  }

  void resetGame() {
    _aiTimer?.cancel();
    state = GameModel.initial();
  }
}
