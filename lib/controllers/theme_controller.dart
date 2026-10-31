import 'package:flutter/material.dart';

final class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  void toggle(Brightness current) {
    value = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
