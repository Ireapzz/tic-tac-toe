import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tic_tac_toe/core/utils/haptic_feedback.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/models/game_result_animation.dart';
import 'package:tic_tac_toe/features/game/domain/models/player.dart';
import 'package:tic_tac_toe/features/game/presentation/services/rive_animation_service.dart';
import 'package:tic_tac_toe/features/game/presentation/utils/game_result_helper.dart';

class GameResultDialog extends StatefulWidget {
  final GameModel gameState;
  final GameMode gameMode;
  final VoidCallback onReplay;

  const GameResultDialog({
    super.key,
    required this.gameState,
    required this.gameMode,
    required this.onReplay,
  });

  @override
  State<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends State<GameResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final _riveAnimationService = RiveAnimationService();
  late GameResultAnimation _currentAnimation;

  @override
  void initState() {
    super.initState();
    _currentAnimation = GameResultHelper.getAnimation(
      gameState: widget.gameState,
      gameMode: widget.gameMode,
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _playHapticFeedback();
        }
      });
    });
  }

  void _playHapticFeedback() {
    final isDraw = widget.gameState.isDraw;
    final winner = widget.gameState.winner;
    final isVsComputer = widget.gameMode == GameMode.vsComputer;

    if (isDraw) {
      HapticFeedbackHelper.playDraw();
    } else if (isVsComputer) {
      if (winner == Player.x) {
        HapticFeedbackHelper.playWin();
      } else {
        HapticFeedbackHelper.playLoss();
      }
    } else {
      HapticFeedbackHelper.playWin();
    }
  }

  void _onRiveInit(Artboard artboard) {
    _riveAnimationService.initializeAnimation(
      artboard: artboard,
      animation: _currentAnimation,
      isMounted: () => mounted,
    );
  }

  @override
  void dispose() {
    _riveAnimationService.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDraw = widget.gameState.isDraw;
    final winner = widget.gameState.winner;
    final isVsComputer = widget.gameMode == GameMode.vsComputer;

    String title;
    String message;
    Color color;

    if (isDraw) {
      title = 'Match nul';
      message = 'Aucun gagnant cette fois !';
      color = const Color(0xFFF59E0B);
    } else if (isVsComputer) {
      if (winner == Player.x) {
        title = 'Victoire !';
        message = 'Félicitations, vous avez gagné !';
        color = const Color(0xFF10B981);
      } else {
        title = 'Défaite';
        message = 'L\'ordinateur a gagné. Essayez encore !';
        color = const Color(0xFFEF4444);
      }
    } else {
      final winnerName = winner == Player.x ? 'Joueur 1' : 'Joueur 2';
      title = 'Victoire !';
      message = '$winnerName a gagné !';
      color = const Color(0xFF10B981);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).dialogTheme.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  child: SizedBox(
                    width: _currentAnimation.size,
                    height: _currentAnimation.size,
                    child: Container(
                      width: _currentAnimation.size,
                      height: _currentAnimation.size,
                      decoration: BoxDecoration(
                        color: _currentAnimation.needsBackground
                            ? (Theme.of(context).dialogTheme.backgroundColor ??
                                  Theme.of(context).colorScheme.surface)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: RiveAnimation.asset(
                        _currentAnimation.assetPath,
                        fit: BoxFit.contain,
                        onInit: _currentAnimation.needsStateMachine
                            ? _onRiveInit
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onReplay();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh_rounded, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Rejouer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
