import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/game/game_mode_button.dart';
import 'package:tic_tac_toe/core/widgets/section_title.dart';
import 'package:tic_tac_toe/core/theme/widgets/theme_mode_switch.dart';
import 'package:tic_tac_toe/core/theme/theme_mode_controller.dart';

class GameModeSelectionDialog extends ConsumerWidget {
  const GameModeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeControllerProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color:
                Theme.of(context).dialogTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Réglages',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                SectionTitle(title: 'Mode de jeu'),
                const SizedBox(height: 16),
                GameModeButton(
                  icon: Icons.smart_toy_rounded,
                  title: 'Contre l\'ordinateur',
                  description: 'Jouez contre une IA',
                  mode: GameMode.vsComputer,
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 16),
                GameModeButton(
                  icon: Icons.people_rounded,
                  title: 'Contre un ami',
                  description: 'Jouez à deux sur le même écran',
                  mode: GameMode.vsFriend,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 32),
                SectionTitle(title: 'Apparence'),
                const SizedBox(height: 16),
                ThemeModeSwitch(isDarkMode: isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
