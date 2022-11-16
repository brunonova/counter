// Copyright (C) 2022  Bruno Nova
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
import 'package:flutter/services.dart';
import 'package:flutter_common/material.dart';
import 'package:window_size/window_size.dart';

import 'pages/about_page.dart';
import 'pages/counter_page.dart';
import 'pages/settings_page.dart';
import 'notifiers/theme_prefs.dart';

void main() {
  App.run(
    supportedLocales: ["en", "pt"],
    saveLocale: true,
    providers: [
      ChangeNotifierProvider(create: (_) => ThemePrefs()),
    ],
    builder: () => const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemePrefs>(builder: (context, themePrefs, _) {
      // Light color scheme
      final lightColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: themePrefs.colorScheme,
      );

      // Dark color scheme
      final darkColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: themePrefs.colorScheme,
      );

      // Build the MaterialApp
      return MaterialApp.router(
        onGenerateTitle: (context) {
          final title = "appName".tr();
          // Set window title on desktop platforms
          if (PlatformUtils.isDesktop) {
            setWindowTitle(title);
          }
          return title;
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        themeMode: themePrefs.themeMode,
        scrollBehavior: CommonScrollBehavior(),
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            scrollbarTheme: buildCommonScrollbarTheme(context),
            cardTheme: CardTheme(
              elevation: 2,
              color: lightColorScheme.surface,
            ),
            snackBarTheme: SnackBarThemeData(
              actionTextColor: lightColorScheme.primaryContainer,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            )),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: darkColorScheme,
          scrollbarTheme: buildCommonScrollbarTheme(context),
          cardTheme: CardTheme(
            elevation: 2,
            color: darkColorScheme.surfaceVariant,
          ),
          snackBarTheme: SnackBarThemeData(
            actionTextColor: darkColorScheme.primaryContainer,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        routerConfig: _router,
      );
    });
  }
}

/// Router for navigation.
/// Declared outside so that hot reload doesn't reset to the home page.
/// Modifying the router will require a restart, however!
final _router = GoRouter(
  navigatorKey: App.navigatorKey,
  routes: [
    GoRoute(
      path: CounterPage.path,
      builder: (context, state) => const CounterPage(),
    ),
    GoRoute(
      path: SettingsPage.path,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AboutPage.path,
      builder: (context, state) => const AboutPage(),
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(state: state),
);
