import 'package:flutter/material.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import '../widgets/game/game_mode_selection_dialog.dart';
import '../widgets/game/game_result_dialog.dart';
import '../controllers/game_controller.dart';
import '../controllers/game_mode_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameDialogHelper {
  static void showGameModeDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final gameMode = ref.read(gameModeControllerProvider);
    final isFirstTime = gameMode == null;

    showDialog<GameMode>(
      context: context,
      barrierDismissible: !isFirstTime,
      builder: (context) => const GameModeSelectionDialog(),
    ).then((selectedMode) {
      if (selectedMode != null) {
        final currentGameState = ref.read(gameControllerProvider);
        final isGameInProgress =
            !currentGameState.isGameOver &&
            currentGameState.board.any((cell) => cell != null);

        if (isGameInProgress && gameMode != null && selectedMode != gameMode) {
          if (context.mounted) {
            _showModeChangeConfirmationDialog(
              context: context,
              ref: ref,
              newMode: selectedMode,
            );
          }
        } else {
          ref
              .read(gameModeControllerProvider.notifier)
              .setGameMode(selectedMode);
          if (isGameInProgress) {
            ref.read(gameControllerProvider.notifier).resetGame();
          }
        }
      }
    });
  }

  static void _showModeChangeConfirmationDialog({
    required BuildContext context,
    required WidgetRef ref,
    required GameMode newMode,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).dialogTheme.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF6366F1),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Changement de mode',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  'Changer de mode de jeu va redémarrer la partie en cours. Voulez-vous continuer ?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          ref
                              .read(gameModeControllerProvider.notifier)
                              .setGameMode(newMode);
                          ref.read(gameControllerProvider.notifier).resetGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Continuer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static void showResultDialog({
    required BuildContext context,
    required GameModel gameState,
    required GameMode gameMode,
    required WidgetRef ref,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameResultDialog(
        gameState: gameState,
        gameMode: gameMode,
        onReplay: () {
          ref.read(gameControllerProvider.notifier).resetGame();
        },
      ),
    );
  }
}
