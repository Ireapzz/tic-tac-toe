import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/core/theme/theme_mode_controller.dart';

class ThemeModeSwitch extends ConsumerWidget {
  final bool isDarkMode;

  const ThemeModeSwitch({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (isDarkMode ? Colors.blue.shade300 : Colors.amber.shade700)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 28,
              color: isDarkMode ? Colors.blue.shade300 : Colors.amber.shade700,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode sombre',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDarkMode ? 'Thème sombre activé' : 'Thème clair activé',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Switch(
            value: isDarkMode,
            onChanged: (value) {
              ref
                  .read(themeModeControllerProvider.notifier)
                  .setThemeMode(value);
            },
          ),
        ],
      ),
    );
  }
}
