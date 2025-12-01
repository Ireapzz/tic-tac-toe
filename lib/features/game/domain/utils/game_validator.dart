// domain/utils/game_validator.dart
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

class GameValidator {
  static bool canPlayMove({
    required GameModel gameState,
    required GameMode gameMode,
  }) {
    return !gameState.isGameOver &&
        !(gameMode == GameMode.vsComputer &&
            gameState.currentPlayer == Player.o);
  }
}
