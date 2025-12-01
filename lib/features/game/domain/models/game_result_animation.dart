enum GameResultAnimation {
  confetti('assets/animations/confetti.riv', 180),
  handshake('assets/animations/handshake.riv', 180),
  dislike('assets/animations/dislike.riv', 120);

  final String assetPath;
  final double size;

  const GameResultAnimation(this.assetPath, this.size);

  bool get needsStateMachine => this == GameResultAnimation.dislike;
  bool get needsBackground => this == GameResultAnimation.confetti;
}
