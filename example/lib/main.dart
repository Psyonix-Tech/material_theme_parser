import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:material_theme_builder/material_theme_builder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:material_theme_builder_test/view_theme_properties.dart';
import 'package:material_theme_builder_test/widgets_example.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void updateTheme(MaterialThemeColors colors) {
    setState(() {
      _colors = colors;
    });
  }

  void updateThemeMode(ThemeMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  MaterialThemeColors? _colors;
  ThemeMode _mode = ThemeMode.light;
  final bool debugUseHardcodedThemeData = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: debugUseHardcodedThemeData
          ? ThemeData(
              colorScheme: _colors?.toLightColorScheme(),
              backgroundColor: _colors?.toLightColorScheme().background,
              cardColor: _colors?.toLightColorScheme().surface,
              errorColor: _colors?.toLightColorScheme().error,
              primaryColor: _colors?.toLightColorScheme().primary,
              primaryColorLight: _colors?.toLightColorScheme().primary,
              primaryColorBrightness: Brightness.light,
              primaryColorDark: _colors?.toLightColorScheme().primaryVariant,
              // The ThemeData.from is setting this value to (isDark ? colorScheme.onSurface : colorScheme.onPrimary)
              // but the tabbars almost never on materials
              indicatorColor: _colors?.toLightColorScheme().primary,
              canvasColor: _colors?.toLightColorScheme().background,
              scaffoldBackgroundColor: _colors?.toLightColorScheme().background,
              dialogBackgroundColor: _colors?.toLightColorScheme().background,
              dividerColor: _colors?.toLightColorScheme().onSurface.withOpacity(
                  0.12), // this implementation is taken from ThemeData.from
              iconTheme: IconThemeData(
                color: _colors == null
                    ? null
                    : Color(_colors!.mdThemeLightTertiary),
              ),

              toggleableActiveColor: _colors?.toLightColorScheme().primary,
            )
          : ThemeData.from(
              colorScheme:
                  _colors?.toLightColorScheme() ?? const ColorScheme.light(),
            ),
      darkTheme: debugUseHardcodedThemeData
          ? ThemeData(
              colorScheme: _colors?.toDarkColorScheme(),
              iconTheme: IconThemeData(
                color: _colors == null
                    ? null
                    : Color(_colors!.mdThemeDarkTertiary),
              ),
            )
          : ThemeData.from(
              colorScheme:
                  _colors?.toDarkColorScheme() ?? const ColorScheme.dark(),
            ),
      themeMode: _mode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  if (_colors == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select a theme first!')));
                    return;
                  }
                  setState(() {
                    _mode = _mode == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  });
                },
                icon: Icon(_mode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
              );
            })
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Builder(builder: (context) {
                return TabBar(
                  tabs: [
                    'Change Theme',
                    'View Theme Properties',
                    'Widgets Example'
                  ]
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                );
              }),
              const Expanded(
                child: TabBarView(
                  children: [
                    ChangeTheme(),
                    ViewThemeProperties(),
                    WidgetsExample(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              ByteData byteData =
                  await rootBundle.load('assets/material-theme.zip');
              context.findAncestorStateOfType<_MyAppState>()!.updateTheme(
                  MaterialThemeBuilder.themeColorsFromZipFile(
                      byteData.buffer.asUint8List()));
            },
            child: const Text('Read schemes from .zip file'),
          ),
          const SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () async {
              ByteData byteData = await rootBundle.load('assets/colors1.xml');
              context.findAncestorStateOfType<_MyAppState>()!.updateTheme(
                  MaterialThemeBuilder.themeColorsFromXmlFile(
                      byteData.buffer.asUint8List()));
            },
            child: const Text('Read schemes from .xml file'),
          ),
          const SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () async {
              ByteData byteData = await rootBundle.load('assets/colors2.xml');
              context.findAncestorStateOfType<_MyAppState>()!.updateTheme(
                  MaterialThemeBuilder.themeColorsFromXmlString(
                      String.fromCharCodes(byteData.buffer.asUint8List())));
            },
            child: const Text('Read schemes from xml String'),
          ),
        ],
      ),
    );
  }
}
