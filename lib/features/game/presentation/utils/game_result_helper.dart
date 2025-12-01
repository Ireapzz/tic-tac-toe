import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_result_animation.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

class GameResultHelper {
  static GameResultAnimation getAnimation({
    required GameModel gameState,
    required GameMode gameMode,
  }) {
    final isDraw = gameState.isDraw;
    final winner = gameState.winner;
    final isVsComputer = gameMode == GameMode.vsComputer;

    if (isDraw) {
      return GameResultAnimation.handshake;
    } else if (isVsComputer) {
      if (winner == Player.x) {
        return GameResultAnimation.confetti;
      } else {
        return GameResultAnimation.dislike;
      }
    } else {
      return GameResultAnimation.confetti;
    }
  }
}
