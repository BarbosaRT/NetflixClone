import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  TextStyle headline3 = GoogleFonts.arimo(
    letterSpacing: 1,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 45,
  );

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

  // Infos in the login screen
  TextStyle labelLarge = GoogleFonts.arimo(
    letterSpacing: 0.5,
    fontWeight: FontWeight.w100,
    color: const Color.fromRGBO(129, 129, 129, 1),
    fontSize: 15,
  );

  // Duvidas
  TextStyle labelBig = GoogleFonts.arimo(
    fontWeight: FontWeight.w100,
    color: const Color.fromRGBO(129, 129, 129, 1),
    fontSize: 17,
  );

  TextStyle labelIntermedium = GoogleFonts.arimo(
    fontWeight: FontWeight.w100,
    color: const Color.fromRGBO(100, 100, 100, 1),
    fontSize: 13,
  );

  TextStyle labelMedium = GoogleFonts.arimo(
    fontWeight: FontWeight.w100,
    color: const Color.fromRGBO(150, 150, 150, 1),
    fontSize: 13,
  );
}
