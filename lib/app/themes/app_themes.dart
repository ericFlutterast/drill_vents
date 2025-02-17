import 'package:flutter/material.dart';

import 'app_theme_interface.dart';
import 'main/main_theme.dart';

final class AppThemes {
  const AppThemes({required this.main});

  final IAppTheme main;
}

extension MainThemeExtension on BuildContext {
  AppThemes get themes => AppThemes(main: MainTheme());
}
