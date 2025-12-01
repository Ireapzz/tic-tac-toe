import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_mode_controller.g.dart';

@Riverpod()
class GameModeController extends _$GameModeController {
  @override
  GameMode? build() {
    return null;
  }

  void setGameMode(GameMode mode) {
    state = mode;
  }

  void resetGameMode() {
    state = null;
  }
}
