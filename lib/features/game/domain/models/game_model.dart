import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

part 'game_model.freezed.dart';

@freezed
abstract class GameModel with _$GameModel {
  const GameModel._();

  const factory GameModel({
    required List<Player?> board,
    required Player currentPlayer,
    Player? winner,
    @Default(false) bool isDraw,
  }) = _GameModel;

  factory GameModel.initial() {
    return GameModel(board: List.filled(9, null), currentPlayer: Player.x);
  }

  bool get isGameOver => winner != null || isDraw;

  GameModel playMove(int index) {
    if (index < 0 || index >= 9 || board[index] != null || isGameOver) {
      return this;
    }

    final newBoard = List<Player?>.from(board);
    newBoard[index] = currentPlayer;

    final newWinner = checkWinner(newBoard);

    final newIsDraw = newWinner == null && !newBoard.contains(null);

    return copyWith(
      board: newBoard,
      currentPlayer: currentPlayer == Player.x ? Player.o : Player.x,
      winner: newWinner,
      isDraw: newIsDraw,
    );
  }

  static Player? checkWinner(List<Player?> board) {
    // represents the lines of the board
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal lines
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical lines
      [0, 4, 8], [2, 4, 6], // diagonal lines
    ];

    for (final player in Player.values) {
      final hasWon = lines.any(
        (line) => line.every((index) => board[index] == player),
      );

      if (hasWon) return player;
    }
    return null;
  }
}
