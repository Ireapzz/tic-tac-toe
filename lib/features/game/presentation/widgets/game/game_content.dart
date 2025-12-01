import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_controller.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_mode_controller.dart';
import '../player/player_zone.dart';
import 'game_board_section.dart';

class GameContent extends ConsumerWidget {
  const GameContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final gameMode = ref.watch(gameModeControllerProvider);

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PlayerZone(
            player: Player.o,
            isActive: gameState.currentPlayer == Player.o,
            isWinner: gameState.winner == Player.o,
            gameMode: gameMode ?? GameMode.vsComputer,
            isTop: true,
            gameState: gameState,
          ),
        ),

        const Divider(),

        const Expanded(child: GameBoardSection()),

        const Divider(),

        SizedBox(
          height: 150,
          child: PlayerZone(
            player: Player.x,
            isActive: gameState.currentPlayer == Player.x,
            isWinner: gameState.winner == Player.x,
            gameMode: gameMode ?? GameMode.vsFriend,
            isTop: false,
            gameState: gameState,
          ),
        ),
      ],
    );
  }
}
