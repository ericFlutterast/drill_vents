import 'package:drill_events/app/themes/app_theme_interface.dart';
import 'package:drill_events/app/themes/colors_theme.dart';
import 'package:drill_events/app/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class MainTheme implements IAppTheme {
  const MainTheme();

  @override
  AppColors get colors => const AppColors(
    background: Color(0xFFFFFFFF),
    accent: Color(0xFF383838),
    greyDark: Color(0xFFB6B6B6),
    greyLight: Color(0xFFF5F5F5),
    amberBackground: Color(0xFFFAEDDA),
    amberBackgroundAccent: Color(0xFFFFDCA8),
    amberText: Color(0xFFFF9500),
    errorBackground: Color(0xFFFAE8E8),
    errorBackgroundAccent: Color(0xFFFFD6D6),
    errorText: Color(0xFFF04438),
    errorAccent: Color(0xFF912018),
    successBackground: Color(0xFFEAF7E9),
    successBackgroundAccent: Color(0xFFC8F1C6),
    successSecondary: Color(0xFF3EC356),
    successText: Color(0xFF1BA43E),
    successAccent: Color(0xFF0D3D12),
  );

  @override
  AppTexts get texts => AppTexts(
    h1: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 30.08,
      height: 36.1 / 30.08,
      letterSpacing: 1.25,
    ),
    h2: GoogleFonts.robotoFlex(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 24.06,
      height: 28.87 / 24.06,
      letterSpacing: 1.25,
    ),
    h3: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 19.25,
      height: 25.41 / 19.25,
      letterSpacing: 0.6,
    ),
    body: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 15.4,
      height: 1.3,
      letterSpacing: 0.2,
    ),
    bodySmall: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 12.32,
      height: 19.71 / 12.32,
      letterSpacing: 0.2,
    ),
    caption: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 9.86,
      height: 1,
      letterSpacing: 0.4,
    ),
  );
}
