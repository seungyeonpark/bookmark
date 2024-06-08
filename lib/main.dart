import 'package:flutter/material.dart';
import 'page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmarks',
      theme: _buildThemeData(),
      home: BookmarkPage(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF333333),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF333333),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 85,
        titleTextStyle: TextStyle(
          fontSize: 36,
          fontFamily: 'Rubik-Light',
          color: Color(0xFFF5F5F5),
          letterSpacing: 10.0,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFF5F5F5),
        ),
      ),
      textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Rubik-Light',
            color: Color(0xFF333333),
          )
      ),
      cardTheme: CardTheme(
        color: Color(0xFFF5F5F5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xFFF5F5F5),
        titleTextStyle: TextStyle(color: Color(0xFF333333)),
        contentTextStyle: TextStyle(color: Color(0xFF333333)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF333333)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF333333)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF333333)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF333333),
        elevation: 0,
      ),
    );
  }
}
