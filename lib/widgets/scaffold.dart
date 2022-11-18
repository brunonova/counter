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

import '../pages/about_page.dart';
import '../pages/counter_page.dart';
import '../pages/settings_page.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold({
    super.key,
    this.title,
    this.titleColor,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  /// Title of the window (mostly for the web). If given, a [Title] widget will
  /// be used.
  final String? title;

  /// Color for the [Title] widget, if the [title] argument is given.
  final Color? titleColor;

  /// Body of the page.
  final Widget body;

  /// [AppBar] for the [Scaffold].
  final PreferredSizeWidget? appBar;

  /// Optional [FloatingActionButton] for the [Scaffold].
  final Widget? floatingActionButton;

  /// Position of the [FloatingActionButton] on the [Scaffold].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Destinations for navigation.
  final _destinations = [
    RouteDestination(
      path: CounterPage.path,
      icon: Icons.timer,
      text: "counters".tr(),
    ),
    RouteDestination(
      path: SettingsPage.path,
      icon: Icons.settings,
      text: "settings".tr(),
    ),
    RouteDestination(
      path: AboutPage.path,
      icon: Icons.info_outline,
      text: "about".tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: title,
      titleColor: titleColor,
      appBar: appBar,
      body: body,
      minExtendedWidth: 206,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      destinations: _destinations,
      drawerHeader: AppDrawerHeader(
        title: "appName".tr(),
        height: 96,
        gradientBackground: true,
      ),
    );
  }
}
