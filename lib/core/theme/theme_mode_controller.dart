import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

@Riverpod()
class ThemeModeController extends _$ThemeModeController {
  // false = light mode, true = dark mode
  @override
  bool build() {
    return false;
  }

  void toggleTheme() {
    state = !state;
  }

  void setThemeMode(bool isDark) {
    state = isDark;
  }
}
