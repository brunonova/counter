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
import 'package:flutter_common/material.dart';

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

/// The application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemePrefs>(
      builder: (context, themePrefs, _) => CommonMaterialApp(
        appNameStringKey: "appName",
        seedColor: themePrefs.colorScheme,
        routerConfig: _router,
        themeMode: themePrefs.themeMode,
        buildTheme: (context, colorScheme, lightTheme) => CommonTheme.themeData(
          context: context,
          colorScheme: colorScheme,
          cardTheme: CardTheme(
            elevation: 2,
            color:
                lightTheme ? colorScheme.surface : colorScheme.surfaceVariant,
          ),
        ),
      ),
    );
  }
}
