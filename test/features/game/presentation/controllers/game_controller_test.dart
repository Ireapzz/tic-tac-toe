import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_controller.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_mode_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameModeController', () {
    test(
      'initializes the game mode to null and allows setting/resetting it',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final initialMode = container.read(gameModeControllerProvider);
        expect(initialMode, isNull);

        container
            .read(gameModeControllerProvider.notifier)
            .setGameMode(GameMode.vsFriend);
        final setMode = container.read(gameModeControllerProvider);
        expect(setMode, GameMode.vsFriend);

        container.read(gameModeControllerProvider.notifier).resetGameMode();
        final resetMode = container.read(gameModeControllerProvider);
        expect(resetMode, isNull);
      },
    );
  });

  group('GameController', () {
    test('plays a valid move and alternates the current player', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(gameModeControllerProvider.notifier)
          .setGameMode(GameMode.vsFriend);

      final controller = container.read(gameControllerProvider.notifier);

      final initialState = container.read(gameControllerProvider);
      expect(initialState.currentPlayer, Player.x);
      expect(initialState.board[0], isNull);

      controller.playerMove(0);

      final newState = container.read(gameControllerProvider);
      expect(newState.board[0], Player.x);
      expect(newState.currentPlayer, Player.o);
    });

    test('resetGame resets the game state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(gameModeControllerProvider.notifier)
          .setGameMode(GameMode.vsFriend);
      final controller = container.read(gameControllerProvider.notifier);

      controller.playerMove(0);
      var state = container.read(gameControllerProvider);
      expect(state.board[0], isNotNull);

      controller.resetGame();
      state = container.read(gameControllerProvider);
      expect(state.board.where((cell) => cell != null).length, 0);
      expect(state.currentPlayer, Player.x);
      expect(state.winner, isNull);
      expect(state.isDraw, isFalse);
    });

    test('refuses to play on an occupied cell', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(gameModeControllerProvider.notifier)
          .setGameMode(GameMode.vsFriend);
      final controller = container.read(gameControllerProvider.notifier);

      controller.playerMove(0); // X plays
      final stateAfterFirstMove = container.read(gameControllerProvider);

      controller.playerMove(0); // Try to play on same cell
      final stateAfterSecondAttempt = container.read(gameControllerProvider);

      // State should not change
      expect(stateAfterSecondAttempt.board[0], stateAfterFirstMove.board[0]);
      expect(
        stateAfterSecondAttempt.currentPlayer,
        stateAfterFirstMove.currentPlayer,
      );
    });

    test('isGameOver returns true when there is a winner', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(gameModeControllerProvider.notifier)
          .setGameMode(GameMode.vsFriend);
      final controller = container.read(gameControllerProvider.notifier);

      expect(controller.isGameOver, isFalse);

      // Create a winning scenario
      controller.playerMove(0); // X
      controller.playerMove(3); // O
      controller.playerMove(1); // X
      controller.playerMove(4); // O
      controller.playerMove(2); // X wins

      expect(controller.isGameOver, isTrue);
    });
  });
}
