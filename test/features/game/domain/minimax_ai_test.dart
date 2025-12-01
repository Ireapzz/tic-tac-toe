import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/domain/services/minimax_ai.dart';

void main() {
  group('MinimaxAI - getBestMove', () {
    test('plays center on the first move', () {
      final ai = MinimaxAI();
      final game = GameModel.initial();

      final move = ai.getBestMove(game);

      expect(move, 4);
    });

    test('blocks an imminent win from X', () {
      final ai = MinimaxAI();

      final board = <Player?>[
        Player.x,
        Player.x,
        null,
        null,
        Player.o,
        null,
        null,
        null,
        null,
      ];

      final game = GameModel(board: board, currentPlayer: Player.o);

      final move = ai.getBestMove(game);

      expect(move, 2);
    });

    test('takes an immediate winning move when available', () {
      final ai = MinimaxAI();

      final board = <Player?>[
        Player.o,
        Player.o,
        null,
        Player.x,
        Player.x,
        null,
        null,
        null,
        null,
      ];

      final game = GameModel(board: board, currentPlayer: Player.o);

      final move = ai.getBestMove(game);

      expect(move, 2);
    });

    test('plays in a corner when center is taken', () {
      final ai = MinimaxAI();

      final board = <Player?>[
        null,
        null,
        null,
        null,
        Player.x,
        null,
        null,
        null,
        null,
      ];

      final game = GameModel(board: board, currentPlayer: Player.o);

      final move = ai.getBestMove(game);

      expect([0, 2, 6, 8], contains(move));
    });
  });
}
