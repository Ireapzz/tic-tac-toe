enum Player { x, o }

extension PlayerExtension on Player {
  String get name {
    switch (this) {
      case Player.x:
        return 'x';
      case Player.o:
        return 'o';
    }
  }
}
