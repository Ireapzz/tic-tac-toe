import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

void main() {
  group('GameModel.initial', () {
    test(
      'creates a game with an empty board and Player.x as current player',
      () {
        final game = GameModel.initial();

        expect(game.board.length, 9);
        expect(game.board.every((cell) => cell == null), isTrue);
        expect(game.currentPlayer, Player.x);
        expect(game.winner, isNull);
        expect(game.isDraw, isFalse);
        expect(game.isGameOver, isFalse);
      },
    );
  });

  group('GameModel.playMove', () {
    test('plays a valid move on an empty cell', () {
      final game = GameModel.initial();

      final newGame = game.playMove(0);

      expect(newGame.board[0], Player.x);
      expect(newGame.currentPlayer, Player.o);
    });

    test('alternates between players after each move', () {
      var game = GameModel.initial();

      game = game.playMove(0); // X plays
      expect(game.currentPlayer, Player.o);

      game = game.playMove(1); // O plays
      expect(game.currentPlayer, Player.x);

      game = game.playMove(2); // X plays
      expect(game.currentPlayer, Player.o);
    });

    test('refuses to play on an occupied cell', () {
      var game = GameModel.initial();
      game = game.playMove(0);

      final beforeMove = game;
      game = game.playMove(0);

      expect(game, beforeMove);
      expect(game.board[0], Player.x);
      expect(game.currentPlayer, Player.o);
    });

    test('refuses to play with an invalid index (negative)', () {
      final game = GameModel.initial();

      final newGame = game.playMove(-1);

      expect(newGame, game);
    });

    test('refuses to play with an invalid index (>= 9)', () {
      final game = GameModel.initial();

      final newGame = game.playMove(9);

      expect(newGame, game);
    });

    test('detects a winner after a winning move', () {
      var game = GameModel(
        board: [Player.x, Player.x, null, null, null, null, null, null, null],
        currentPlayer: Player.x,
      );

      game = game.playMove(2);

      expect(game.winner, Player.x);
      expect(game.isGameOver, isTrue);
    });

    test('detects a draw when the board is full with no winner', () {
      var game = GameModel(
        board: [
          Player.x,
          Player.o,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.o,
          Player.x,
          null,
        ],
        currentPlayer: Player.x,
      );

      game = game.playMove(8);

      expect(game.isDraw, isTrue);
      expect(game.winner, isNull);
      expect(game.isGameOver, isTrue);
    });
  });

  group('GameModel.checkWinner', () {
    test('detects horizontal win on first row', () {
      final board = [
        Player.x,
        Player.x,
        Player.x,
        null,
        null,
        null,
        null,
        null,
        null,
      ];

      final winner = GameModel.checkWinner(board);

      expect(winner, Player.x);
    });

    test('detects vertical win on first column', () {
      final board = [
        Player.o,
        null,
        null,
        Player.o,
        null,
        null,
        Player.o,
        null,
        null,
      ];

      final winner = GameModel.checkWinner(board);

      expect(winner, Player.o);
    });

    test('detects diagonal win (top-left to bottom-right)', () {
      final board = [
        Player.x,
        null,
        null,
        null,
        Player.x,
        null,
        null,
        null,
        Player.x,
      ];

      final winner = GameModel.checkWinner(board);

      expect(winner, Player.x);
    });

    test('returns null when there is no winner', () {
      final board = [
        Player.x,
        Player.o,
        null,
        null,
        Player.x,
        null,
        null,
        null,
        Player.o,
      ];

      final winner = GameModel.checkWinner(board);

      expect(winner, isNull);
    });
  });
}
