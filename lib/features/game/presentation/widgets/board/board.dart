import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/presentation/controllers/game_controller.dart';
import 'cell.dart';

class Board extends ConsumerWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardCells = ref.watch(gameControllerProvider.select((s) => s.board));
    const spacing = 10.0;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Cell(index: index, cellValue: boardCells[index]);
      },
    );
  }
}
