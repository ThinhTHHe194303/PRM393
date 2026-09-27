import 'package:flutter/material.dart';

class ScaffoldThemeDemo extends StatefulWidget {
  const ScaffoldThemeDemo({super.key});

  @override
  State<ScaffoldThemeDemo> createState() =>
      _ScaffoldThemeDemoState();
}

class _ScaffoldThemeDemoState
    extends State<ScaffoldThemeDemo> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),

      themeMode:
      isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Flutter App'),

          actions: [
            Switch(
              value: isDarkMode,

              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),

        body: const Center(
          child: Text(
            'Hello Flutter!',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('FAB clicked');
          },

          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}