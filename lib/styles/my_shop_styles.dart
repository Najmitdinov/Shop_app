import 'package:flutter/material.dart';

class MyShopStyles {
  static ThemeData theme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontFamily: 'Maat_Rounded',
      ),
      color: Colors.amber,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    fontFamily: 'Maat_Rounded',
  );
}
