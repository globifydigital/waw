import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData themeData(){
  return ThemeData(
    primaryColor: Color(0xFF8FAEF2),
    primaryColorLight: Color(0xFFFFFFFF),
    primaryColorDark: Color(0xFF000000),
    highlightColor: Color(0xFFF3F3F7),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(8),
      hintStyle: const TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16),
      labelStyle: const TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0,color: Colors.transparent,),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0,color: Colors.transparent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0,color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0,color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0,color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0,color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),

      filled: true,
      fillColor: Colors.grey[100],
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
    primaryTextTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
      headlineSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: Colors.black),
      headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 50),
      displayLarge: TextStyle(color: customButtonColor, fontWeight: FontWeight.w700,fontSize: 50),
      displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
      displaySmall: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500,fontSize: 13),
      titleMedium: TextStyle(color: Color(0xFFB7B6C0), fontSize: 11, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16),
      titleSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      /// Normal Text
      labelLarge: TextStyle(color: Color(0xFF7c7e7d),fontSize:12),
      labelMedium: TextStyle(color: Colors.black, fontSize: 14,),
      labelSmall: TextStyle(color: Colors.black, fontSize: 16,),
      /// grey color Text
      bodySmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10, fontWeight: FontWeight.w500,letterSpacing: 0.3),
      bodyLarge: TextStyle(color: Color(0xFF909090), fontSize: 18, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Color(0xFF909090),fontSize: 13, fontWeight: FontWeight.w400,letterSpacing: 0),
    ),
    scaffoldBackgroundColor: Colors.white,
    dividerTheme: const DividerThemeData(color: Colors.black38),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Colors.white, size: 30),
      iconTheme: IconThemeData(color: Color(0XFF1875D3), size: 30),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF8FAEF2)),
        elevation: MaterialStateProperty.all(0.5),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        padding: MaterialStateProperty.all(EdgeInsets.all(5)),
      ),

    ),
  );
}