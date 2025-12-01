import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_statistics.freezed.dart';

// TODO: Add statistics for the games
@freezed
abstract class GameStatistics with _$GameStatistics {
  const factory GameStatistics({
    @Default(0) int totalGames,
    @Default(0) int wins,
    @Default(0) int losses,
    @Default(0) int draws,
  }) = _GameStatistics;

  const GameStatistics._();

  double get winRate => totalGames > 0 ? (wins / totalGames) * 100 : 0;
  double get lossRate => totalGames > 0 ? (losses / totalGames) * 100 : 0;
  double get drawRate => totalGames > 0 ? (draws / totalGames) * 100 : 0;
}
