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

/// [ChangeNotifier] to handle theme preferences.
class ThemePrefs extends ChangeNotifier {
  var _themeMode =
      ThemeMode.values.byName(App.prefs.getString("themeMode") ?? "system");
  var _colorScheme = App.prefs.getString("color") ?? "green";
  var _compactMode = App.prefs.getBool("compactMode") ?? false;

  /// Current theme.
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode val) {
    _themeMode = val;
    App.prefs.setString("themeMode", val.name);
    notifyListeners();
  }

  /// Color scheme name for translation
  String get colorSchemeName => _colorScheme;

  set colorSchemeName(String val) {
    _colorScheme = val;
    App.prefs.setString("color", val);
    notifyListeners();
  }

  /// Color scheme
  MaterialColor get colorScheme =>
      colorSchemeChoices[_colorScheme] ?? Colors.green;

  /// Compact mode
  bool get compactMode => _compactMode;

  set compactMode(bool val) {
    _compactMode = val;
    App.prefs.setBool("compactMode", val);
    notifyListeners();
  }

  /// Choices for the color schemes
  static const colorSchemeChoices = {
    "lightGreen": Colors.lightGreen,
    "green": Colors.green,
    "teal": Colors.teal,
    "cyan": Colors.cyan,
    "blue": Colors.blue,
    "indigo": Colors.indigo,
    "deepPurple": Colors.deepPurple,
    "purple": Colors.purple,
    "pink": Colors.pink,
    "red": Colors.red,
    "brown": Colors.brown,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "lime": Colors.lime,
  };
}
