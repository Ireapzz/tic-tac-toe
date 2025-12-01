import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

class MinimaxAI {
  int getBestMove(GameModel gameModel) {
    final emptyCells = _getEmptyCells(gameModel.board);

    // TODO: Add difficulty levels (easy, medium, hard)
    if (emptyCells.length == 9) {
      return 4;
    }
    if (emptyCells.length == 8 && gameModel.board[4] == null) {
      return 4;
    }

    int bestScore = -1000;
    int bestMove = -1;

    for (final index in emptyCells) {
      final newBoard = List<Player?>.from(gameModel.board);
      newBoard[index] = Player.o;

      final score = _minimax(newBoard, 0, false, Player.x);

      if (score > bestScore) {
        bestScore = score;
        bestMove = index;
      }
    }

    return bestMove;
  }

  int _minimax(
    List<Player?> board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
  ) {
    final winner = GameModel.checkWinner(board);
    final isDraw = winner == null && !board.contains(null);

    if (winner == Player.o) {
      return 10 - depth;
    }
    if (winner == Player.x) {
      return depth - 10;
    }
    if (isDraw) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          final newBoard = List<Player?>.from(board);
          newBoard[i] = Player.o;
          final score = _minimax(newBoard, depth + 1, false, aiPlayer);
          bestScore = score > bestScore ? score : bestScore;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          final newBoard = List<Player?>.from(board);
          newBoard[i] = Player.x;
          final score = _minimax(newBoard, depth + 1, true, aiPlayer);
          bestScore = score < bestScore ? score : bestScore;
        }
      }
      return bestScore;
    }
  }

  List<int> _getEmptyCells(List<Player?> board) {
    final emptyCells = <int>[];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        emptyCells.add(i);
      }
    }
    return emptyCells;
  }
}
