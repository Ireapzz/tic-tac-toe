import 'package:flutter/services.dart';

class HapticFeedbackHelper {
  static void playMove() {
    HapticFeedback.selectionClick();
  }

  static void playWin() {
    HapticFeedback.heavyImpact();
  }

  static void playLoss() {
    HapticFeedback.mediumImpact();
  }

  static void playDraw() {
    HapticFeedback.lightImpact();
  }

  static void playError() {
    HapticFeedback.vibrate();
  }
}
