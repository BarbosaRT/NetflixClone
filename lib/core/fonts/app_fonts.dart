import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  TextStyle headline4 = GoogleFonts.arimo(
    letterSpacing: 1,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );

  TextStyle headline6 = GoogleFonts.roboto(
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: 17,
  );
  TextStyle headline7 = GoogleFonts.arimo();
}
