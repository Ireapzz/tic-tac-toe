import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import '../controllers/game_controller.dart';
import '../controllers/game_mode_controller.dart';
import '../widgets/game/game_content.dart';
import '../../domain/utils/game_state_listener_helper.dart';
import '../utils/game_dialog_helper.dart';
import '../utils/game_actions_helper.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _hasShownResultDialog = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GameDialogHelper.showGameModeDialog(context: context, ref: ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameMode = ref.watch(gameModeControllerProvider);

    ref.listen<GameModel>(gameControllerProvider, (previous, next) {
      if (GameStateListenerHelper.shouldShowResultDialog(
        previous: previous,
        next: next,
        hasShownResultDialog: _hasShownResultDialog,
        gameMode: gameMode,
      )) {
        _hasShownResultDialog = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GameDialogHelper.showResultDialog(
            context: context,
            gameState: next,
            gameMode: gameMode!,
            ref: ref,
          );
        });
      }

      if (GameStateListenerHelper.hasNewGameStarted(previous, next)) {
        _hasShownResultDialog = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => GameActionsHelper.resetGame(ref),
            tooltip: 'Nouvelle partie',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              GameDialogHelper.showGameModeDialog(context: context, ref: ref);
            },
            tooltip: 'Réglages',
          ),
        ],
      ),
      body: SafeArea(
        child: gameMode == null
            ? const Center(child: CircularProgressIndicator())
            : const GameContent(),
      ),
    );
  }
}
