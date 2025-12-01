import 'package:flutter/material.dart';
import '../board/board.dart';

class GameBoardSection extends StatelessWidget {
  const GameBoardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: AspectRatio(aspectRatio: 1, child: const Board()),
    );
  }
}
