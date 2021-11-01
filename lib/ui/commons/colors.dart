import 'package:flutter/material.dart';

const Color kColorBackground = Color(0xffefe6d0);
const Color kColorBackgroundDark = Color.fromARGB(255, 36, 36, 36);
const Color kColorBackgroundMiddle = Color.fromARGB(255, 80, 80, 80);

const Color kColorCopper = Color.fromARGB(255, 180, 120, 0);
const Color kColorAccent = Color.fromARGB(255, 214, 0, 0);

const Color kColorMainRed = Color(0xFFC60000);
const Color kColorDarkRed = Color(0xFF4B0000);

const LinearGradient kGradientStone = LinearGradient(
  colors: [Color(0xFFE0C081), Color(0xFFC4A15C)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient kGradientNavigation = LinearGradient(
  colors: [kColorMainRed, kColorDarkRed],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

ThemeData get themeData => ThemeData(
    primaryColor: kColorBackgroundDark,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 40, color: Colors.red),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        elevation: 0),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: Colors.white)),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: kColorMainRed));
