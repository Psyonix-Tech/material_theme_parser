import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class ViewThemeProperties extends StatefulWidget {
  const ViewThemeProperties({Key? key}) : super(key: key);

  @override
  State<ViewThemeProperties> createState() => _ViewThemePropertiesState();
}

class _ViewThemePropertiesState extends State<ViewThemeProperties> {
  bool fromSwatch = false;

  MaterialColor toMaterialColor(Color color) {
    Map<int, Color> getSwatch(Color color) {
      final hslColor = HSLColor.fromColor(color);
      final lightness = hslColor.lightness;

      /// if [500] is the default color, there are at LEAST five
      /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
      /// divisor of 5 would mean [50] is a lightness of 1.0 or
      /// a color of #ffffff. A value of six would be near white
      /// but not quite.
      const lowDivisor = 6;

      /// if [500] is the default color, there are at LEAST four
      /// steps above [500]. A divisor of 4 would mean [900] is
      /// a lightness of 0.0 or color of #000000
      const highDivisor = 5;

      final lowStep = (1.0 - lightness) / lowDivisor;
      final highStep = lightness / highDivisor;

      return {
        50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
        100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
        200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
        300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
        400: (hslColor.withLightness(lightness + lowStep)).toColor(),
        500: (hslColor.withLightness(lightness)).toColor(),
        600: (hslColor.withLightness(lightness - highStep)).toColor(),
        700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
        800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
        900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
      };
    }

    return MaterialColor(color.value, getSwatch(color));
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
          return SingleChildScrollView(
            child: Column(
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
                                'This will create a swatch by manipulating lightness, ',
                          ),
                          TextSpan(
                            text:
                                'Color luminance is totally different concept',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ', and some value migh be wrong.'),
                        ],
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        fromSwatch = value;
                      });
                    }),
                Padding(
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
                        variant: Theme.of(context).colorScheme.secondaryVariant,
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
              ],
            ),
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
