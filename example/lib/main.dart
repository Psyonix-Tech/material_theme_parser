import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:material_theme_builder/material_theme_builder.dart';
import 'package:flutter/services.dart'
    show rootBundle, Clipboard, ClipboardData;

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: _colors?.toLightColorScheme(),
      ),
      darkTheme: ThemeData(colorScheme: _colors?.toDarkColorScheme()),
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
          length: 2,
          child: Column(
            children: [
              Builder(builder: (context) {
                return TabBar(
                  tabs: ['Change Theme', 'View Theme Properties']
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  automaticIndicatorColorAdjustment: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                );
              }),
              const Expanded(
                child: TabBarView(
                  children: [ChangeTheme(), ViewThemeProperties()],
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                color: const Color.fromARGB(255, 103, 80, 164),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                width: 100,
                height: 100,
                color: const Color(0xff6750A4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewThemeProperties extends StatefulWidget {
  const ViewThemeProperties({Key? key}) : super(key: key);

  @override
  State<ViewThemeProperties> createState() => _ViewThemePropertiesState();
}

class _ViewThemePropertiesState extends State<ViewThemeProperties> {
  bool fromSwatch = false;
  MaterialColor toMaterialColor(Color color) {
    Map<int, Color> map = {
      50: Color.fromRGBO(color.red, color.green, color.blue, .1),
      100: Color.fromRGBO(color.red, color.green, color.blue, .2),
      200: Color.fromRGBO(color.red, color.green, color.blue, .3),
      300: Color.fromRGBO(color.red, color.green, color.blue, .4),
      400: Color.fromRGBO(color.red, color.green, color.blue, .5),
      500: Color.fromRGBO(color.red, color.green, color.blue, .6),
      600: Color.fromRGBO(color.red, color.green, color.blue, .7),
      700: Color.fromRGBO(color.red, color.green, color.blue, .8),
      800: Color.fromRGBO(color.red, color.green, color.blue, .9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1),
    };
    return MaterialColor(color.value, map);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      ColorScheme scheme = Theme.of(context).colorScheme;
      if (fromSwatch) {
        scheme = ColorScheme.fromSwatch(
            primarySwatch: toMaterialColor(scheme.primary));
      }
      return Theme(
        data: Theme.of(context).copyWith(colorScheme: scheme),
        child: Builder(builder: (context) {
          return Column(
            children: [
              SwitchListTile(
                  value: fromSwatch,
                  title: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Use '),
                        TextSpan(
                          text: 'ColorScheme.fromSwatch',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: 'variant '),
                      ],
                    ),
                  ),
                  subtitle: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'This will create a swatch by manipulating opacity, ',
                        ),
                        TextSpan(
                          text:
                              'Color luminance is totally a different concept',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ', this is just a test tool.'),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fromSwatch = value;
                    });
                  }),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // primary
                        PropertyPreview(
                          name: 'Primary',
                          color: Theme.of(context).colorScheme.primary,
                          onColor: Theme.of(context).colorScheme.onPrimary,
                          variant: Theme.of(context).colorScheme.primaryVariant,
                          orientation: orientation,
                        ),
                        // Secondary
                        PropertyPreview(
                          name: 'Secondary',
                          color: Theme.of(context).colorScheme.secondary,
                          onColor: Theme.of(context).colorScheme.onSecondary,
                          variant:
                              Theme.of(context).colorScheme.secondaryVariant,
                          orientation: orientation,
                        ),
                        // Error
                        PropertyPreview(
                          name: 'Error',
                          color: Theme.of(context).colorScheme.error,
                          onColor: Theme.of(context).colorScheme.onError,
                          orientation: orientation,
                        ),
                        // Background
                        PropertyPreview(
                          name: 'Background',
                          color: Theme.of(context).colorScheme.background,
                          onColor: Theme.of(context).colorScheme.onBackground,
                          shouldBeReplaced: true,
                          orientation: orientation,
                        ),
                        // Surface
                        PropertyPreview(
                          name: 'Surface',
                          color: Theme.of(context).colorScheme.surface,
                          onColor: Theme.of(context).colorScheme.onSurface,
                          hasDivider: false,
                          shouldBeReplaced: true,
                          orientation: orientation,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }
}

class PropertyPreview extends StatelessWidget {
  final String name;
  final Color color;
  final Color onColor;
  final Color? variant;
  final bool hasDivider;
  final Orientation orientation;
  final bool shouldBeReplaced;

  const PropertyPreview({
    Key? key,
    this.shouldBeReplaced = false,
    required this.name,
    required this.orientation,
    required this.color,
    required this.onColor,
    this.variant,
    this.hasDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name + ' Color',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: shouldBeReplaced
                    ? Theme.of(context).colorScheme.primary
                    : color,
                letterSpacing: 1.6,
              ),
        ),
        const SizedBox(height: 16.0),
        Builder(
          builder: (BuildContext context) {
            List<Widget> children = [
              PreviewContainer(
                name: name,
                background: color,
                foreground: onColor,
              ),
              PreviewContainer(
                name: 'on' + name,
                background: onColor,
                foreground: color,
              ),
              if (variant != null)
                PreviewContainer(
                  name: 'Variant',
                  background: variant!,
                  foreground: Colors.white,
                ),
            ];
            if (orientation == Orientation.portrait) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );
            } else {
              // to make sure it's fully responsive we calculate the left width space
              // double width = MediaQuery.of(context).size.width - 48;
              // width -= 48;
              // width /= 2;
              children = children
                  .map(
                    (e) => SizedBox(
                      width: 300,
                      child: e,
                    ),
                  )
                  .toList();
              return Wrap(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: children,
                spacing: 16.0,
                // children: [
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       for (var i = 0; i < 2; i++) children[i],
                //     ],
                //   ),
                //   if (children.length == 3) children[2],
                // ],
              );
            }
          },
        ),
        const SizedBox(height: 16.0),
        if (hasDivider) ...[
          Divider(
              color: shouldBeReplaced
                  ? Theme.of(context).colorScheme.primary
                  : color),
          const SizedBox(height: 16.0),
        ]
      ],
    );
  }
}

class PreviewContainer extends StatelessWidget {
  final String name;
  final Color background;
  final Color foreground;
  final bool isOn;
  const PreviewContainer({
    Key? key,
    required this.name,
    required this.background,
    required this.foreground,
    this.isOn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 150,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: InkWell(
            onTap: () async {
              String data = '0x' + background.value.toRadixString(16);
              await Clipboard.setData(ClipboardData(text: data));
              ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
              messenger.clearMaterialBanners();
              messenger.showMaterialBanner(
                MaterialBanner(
                  elevation: 5.0,
                  content: Text.rich(
                    TextSpan(
                      text: 'Color',
                      children: [
                        TextSpan(
                          text: ' ($data) ',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: 'is copied to your clipboard '),
                        WidgetSpan(
                          child: Icon(
                            Icons.copy,
                            size:
                                Theme.of(context).textTheme.bodyText2!.fontSize,
                          ),
                        ),
                        const TextSpan(text: ' .'),
                      ],
                    ),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () {
                        messenger.hideCurrentMaterialBanner();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ],
                ),
              );
              await Future.delayed(const Duration(seconds: 5));
              messenger.hideCurrentMaterialBanner();
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
