import 'package:flutter/material.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';

class PlayerZone extends StatelessWidget {
  final Player player;
  final bool isActive;
  final bool isWinner;
  final GameMode gameMode;
  final bool isTop;
  final GameModel gameState;

  const PlayerZone({
    super.key,
    required this.player,
    required this.isActive,
    required this.isWinner,
    required this.gameMode,
    required this.isTop,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    final playerName = gameMode == GameMode.vsComputer && player == Player.o
        ? 'Ordinateur'
        : player == Player.x
        ? 'Joueur 1'
        : 'Joueur 2';

    final playerColor = player == Player.x
        ? const Color(0xFF3B82F6)
        : const Color(0xFFEF4444);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isActive
            ? playerColor.withValues(alpha: 0.1)
            : Colors.transparent,
        border: Border(
          top: isTop && isActive
              ? BorderSide(color: playerColor, width: 3)
              : BorderSide.none,
          bottom: !isTop && isActive
              ? BorderSide(color: playerColor, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              playerName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: isActive
                    ? playerColor.withValues(alpha: 0.1)
                    : Theme.of(context).cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? playerColor
                      : Theme.of(context).dividerColor,
                  width: isActive ? 2.0 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  player.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: playerColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 30,
              child: Opacity(
                opacity: (isActive && !isWinner && !gameState.isDraw)
                    ? 1.0
                    : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: playerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: playerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'À votre tour',
                        style: TextStyle(
                          color: playerColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
