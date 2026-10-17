import 'package:flutter/material.dart';
import 'package:lab4/InputControlsDemo.dart';
import 'package:lab4/fix_debug_demo.dart';
import 'package:lab4/layout_demo.dart';
import 'package:lab4/scaffold_theme_demo.dart';

import 'core_widgets_demo.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CoreWidgetsDemo(),
      // home: InputcontrolsDemo(),
      // home: LayoutBasicsDemo(),
      // home: ScaffoldThemeDemo(),
      // Exercise 5 - Debug & Fix Common UI Errors
      // home: Scaffold(body: Fix1ListViewInColumn()),
      // home: Scaffold(body: Fix2Overflow()),
      // home: Fix3SetState(),
      home: Fix4DatePicker(),
    ),
  );
}
