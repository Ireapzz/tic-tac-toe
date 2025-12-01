import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_controller.dart';
import 'package:tic_tac_toe/features/game/presentation/utils/game_actions_helper.dart';
import 'package:tic_tac_toe/core/utils/haptic_feedback.dart';

class Cell extends ConsumerWidget {
  final int index;
  final Player? cellValue;

  const Cell({super.key, required this.index, required this.cellValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPlay = GameActionsHelper.canPlayMove(ref);

    final playerColor = cellValue == Player.x
        ? const Color(0xFF3B82F6)
        : const Color(0xFFEF4444);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canPlay
            ? () {
                HapticFeedbackHelper.playMove();
                ref.read(gameControllerProvider.notifier).playerMove(index);
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: canPlay
                ? Theme.of(context).cardColor
                : Theme.of(context).cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cellValue != null
                  ? playerColor.withValues(alpha: 0.3)
                  : Theme.of(context).dividerColor,
              width: cellValue != null ? 2 : 1.5,
            ),
            boxShadow: canPlay && cellValue == null
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).shadowColor.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedScale(
              scale: cellValue == null ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: Text(
                cellValue == null ? '' : cellValue!.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  color: playerColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
