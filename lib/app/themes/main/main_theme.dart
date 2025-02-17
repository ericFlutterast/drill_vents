import 'package:drill_events/app/themes/app_theme_interface.dart';
import 'package:drill_events/app/themes/colors_theme.dart';
import 'package:drill_events/app/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class MainTheme implements IAppTheme {
  const MainTheme();

  @override
  AppColors get colors => AppColors(
    background: Color(0xFFFFFFFF),
    accent: Color(0xFF383838),
    greyDark: Color(0xFFB6B6B6),
    greyLight: Color(0xFFF5F5F5),
  );

  @override
  AppTexts get texts => AppTexts(
    h1: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 30.08,
      height: 30.08 / 36.1,
      letterSpacing: 1.25,
    ),
    h2: GoogleFonts.robotoFlex(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 24.06,
      height: 24.06 / 28.87,
      letterSpacing: 1.25,
    ),
    h3: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 19.25,
      height: 19.25 / 25.41,
      letterSpacing: 0.6,
    ),
    body: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 15.4,
      height: 15.4 / 24.64,
      letterSpacing: 0.2,
    ),
    bodySmall: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 12.32,
      height: 12.32 / 19.71,
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
