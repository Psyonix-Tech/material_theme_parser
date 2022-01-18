import 'model.dart';
import 'package:flutter/material.dart';

extension Converter on MaterialThemeColors {
  ColorScheme toLightColorScheme() => ColorScheme(
        primary: Color(mdThemeLightPrimary),
        primaryVariant: Color(mdThemeLightPrimaryContainer),
        onPrimary: Color(mdThemeLightOnPrimary),
        secondary: Color(mdThemeLightSecondary),
        secondaryVariant: Color(mdThemeLightSecondaryContainer),
        onSecondary: Color(mdThemeLightOnSecondary),
        surface: Color(mdThemeLightSurface),
        onSurface: Color(mdThemeLightOnSurface),
        background: Color(mdThemeLightBackground),
        onBackground: Color(mdThemeLightOnBackground),
        error: Color(mdThemeLightError),
        onError: Color(mdThemeLightOnError),
        brightness: Brightness.light,
      );
  ColorScheme toDarkColorScheme() => ColorScheme(
        primary: Color(mdThemeDarkPrimary),
        primaryVariant: Color(mdThemeDarkPrimaryContainer),
        onPrimary: Color(mdThemeDarkOnPrimary),
        secondary: Color(mdThemeDarkSecondary),
        secondaryVariant: Color(mdThemeDarkSecondaryContainer),
        onSecondary: Color(mdThemeDarkOnSecondary),
        surface: Color(mdThemeDarkSurface),
        onSurface: Color(mdThemeDarkOnSurface),
        background: Color(mdThemeDarkBackground),
        onBackground: Color(mdThemeDarkOnBackground),
        error: Color(mdThemeDarkError),
        onError: Color(mdThemeDarkOnError),
        brightness: Brightness.dark,
      );
}
