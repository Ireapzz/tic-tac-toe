import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/utils/game_validator.dart';
import '../controllers/game_controller.dart';
import '../controllers/game_mode_controller.dart';

class GameActionsHelper {
  static void resetGame(WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).resetGame();
  }

  static void resetGameAndMode(WidgetRef ref) {
    ref.read(gameModeControllerProvider.notifier).resetGameMode();
    ref.read(gameControllerProvider.notifier).resetGame();
  }

  static bool canPlayMove(WidgetRef ref) {
    final gameState = ref.read(gameControllerProvider);
    final gameMode = ref.read(gameModeControllerProvider);

    return GameValidator.canPlayMove(
      gameState: gameState,
      gameMode: gameMode ?? GameMode.vsComputer,
    );
  }
}
