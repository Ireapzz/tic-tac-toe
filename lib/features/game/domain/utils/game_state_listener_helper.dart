import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';

class GameStateListenerHelper {
  static bool hasGameJustEnded(GameModel? previous, GameModel next) {
    return previous != null && !previous.isGameOver && next.isGameOver;
  }

  static bool hasNewGameStarted(GameModel? previous, GameModel next) {
    return previous != null && previous.isGameOver && !next.isGameOver;
  }

  static bool shouldShowResultDialog({
    required GameModel? previous,
    required GameModel next,
    required bool hasShownResultDialog,
    required GameMode? gameMode,
  }) {
    return hasGameJustEnded(previous, next) &&
        !hasShownResultDialog &&
        gameMode != null;
  }
}
