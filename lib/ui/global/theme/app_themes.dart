import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppTheme { BlueDark, BlueLight }
final appThemeData = {
  AppTheme.BlueDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
  ),
  AppTheme.BlueLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue[700],
  ),
};
