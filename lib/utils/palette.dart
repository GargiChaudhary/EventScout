import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor myPink = MaterialColor(
    0xfff6a192, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xfff6a192), //10%
      100: Color(0xfff6a192), //20%
      200: Color(0xfff6a192), //30%
      300: Color(0xfff6a192), //40%
      400: Color(0xfff6a192), //50%
      500: Color(0xfff6a192), //60%
      600: Color(0xFFF08977), //70%
      700: Color(0xFFF08977), //80%
      800: Color(0xFFF3826E), //90%
      900: Color(0xFFF47D68), //100%
    },
  );
}
