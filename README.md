<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
<!-- Badges Start  -->

TODO: Add the workflow file name here to show the badge

![example workflow](https://github.com/Psyonix-Tech/material_theme_parser/actions/workflows/<WORKFLOW_FILE>/badge.svg)


<!-- Badges End -->
Parsing Material theme from the [official material website](https://material-foundation.github.io/material-theme-builder/) into flutter's ColorScheme.

## Features
This packages parses the `material-theme.zip` or `colors.xml` when exported from [official material website](https://material-foundation.github.io/material-theme-builder/) as Android Views (XML).

This package is written in pure dart so feel free to use it in any project for any platform, with support for cli apps. 
TODO: List what your package can do. Maybe include images, gifs, or videos.

## Note

When you download a `material-theme.zip` from [official material website](https://material-foundation.github.io/material-theme-builder/) as Android Views (XML) the hierarchy tree inside the `material-theme.zip` will be like this.
```
\---material-theme
    +---values
    |       colors2.xml
    |       themes.xml
    |
    \---values-night
            themes.xml
```
The only file this package takes into account is `material-theme/values/colors.xml`, here is where the magic happens.

`material-theme/values-night/themes.xml` only contains refrences from `material-theme/values/colors.xml`, so we only mapping the values `material-theme/values/colors.xml` in the package.

## Getting started

start using the package.
To use this plugin, add `material_theme_builder` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

But before here is a link to [preview of the project](TODO:Add the github page link here.)

## Usage
### First Step
Import it by adding this line with your imports.
```dart
import 'package:material_theme_builder/material_theme_builder.dart';
```

### Second
Load your asset file as `Uint8List` .
```dart
String assetFile =// your asset here;
ByteData rawBytes = await rootBundle.load(assetFile); //rootBundle can be obtained from package:flutter/services.dart
Uint8List bytes = rawBytes.buffer.asUint8List();
MaterialThemeColors themeColors;//
```
then If the `bytes` represents `.zip` .

```dart
themeColors = MaterialThemeBuilder.themeColorsFromZipFile(bytes);
```
Or if the `bytes` represents `.xml` .
```dart
themeColors = MaterialThemeBuilder.themeColorsFromXmlFile(bytes);
```
Or if you have a `String` representation of the `.xml` file.

```dart
themeColors = MaterialThemeBuilder.themeColorsFromXmlString(xmlString);
```

### Last
The `MaterialThemeColors` class has two helpfull methods to generate `ColorScheme` you can use theme in your `MaterialApp`. 

```dart
MaterialApp(
  theme: ThemeData.from(colorScheme: themeColors.toLightColorScheme()),
  darkTheme: ThemeData.from(colorScheme: themeColors.toDarkColorScheme()),
)
```


## Contribution

If you liked the project please share the love by hitting the star button at the [github](https://github.com/Psyonix-Tech/material_theme_parser) project or the like button ad the [pub](TODO:add the link to the pub page) page.

All if you have an issue or you want to help please consider file [an issue at github](https://github.com/Psyonix-Tech/material_theme_parser/issues) or open a [new pull request.](https://github.com/Psyonix-Tech/material_theme_parser/pulls)