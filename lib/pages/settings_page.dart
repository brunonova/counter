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

import '../notifiers/theme_prefs.dart';
import '../widgets/scaffold.dart';

class SettingsPage extends StatelessWidget {
  /// Path of this page for navigation
  static const path = "/settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemePrefs>(builder: (context, themePrefs, _) {
      return AppScaffold(
        title: "${'settings'.tr()} - ${'appName'.tr()}",
        appBar: AppBar(
          title: const Text("settings").tr(),
        ),
        body: SettingsList(
          padLeft: true,
          sections: [
            SettingsSection(
              title: const Text("prefs.appearance").tr(),
              options: [
                SettingsTile.choice(
                  context: context,
                  title: const Text("prefs.theme").tr(),
                  leading: Icon(
                    context.theme.brightness == Brightness.light
                        ? Icons.light_mode
                        : Icons.dark_mode_outlined,
                  ),
                  value: Text("prefs.${themePrefs.themeMode.name}").tr(),
                  dialogTitle: "prefs.theme".tr(),
                  buildChoices: () => {
                    "prefs.system".tr(): ThemeMode.system,
                    "prefs.light".tr(): ThemeMode.light,
                    "prefs.dark".tr(): ThemeMode.dark,
                  },
                  onChosen: (choice) => themePrefs.themeMode = choice,
                ),
                SettingsTile.colorSchemeChoice(
                  context: context,
                  title: const Text("prefs.colorScheme").tr(),
                  leading: const Icon(Icons.palette),
                  value: Text("color.${themePrefs.colorSchemeName}").tr(),
                  dialogTitle: "prefs.colorScheme".tr(),
                  buildChoices: () => ThemePrefs.colorSchemeChoices,
                  onChosen: (choice) => themePrefs.colorSchemeName = choice,
                  displayColorNames: true,
                ),
                SettingsTile.toggle(
                  title: const Text("prefs.compactMode").tr(),
                  leading: const Icon(Icons.table_rows),
                  toggled: themePrefs.compactMode,
                  onToggled: () =>
                      themePrefs.compactMode = !themePrefs.compactMode,
                ),
              ],
            ),
            SettingsSection(
              title: const Text("prefs.region").tr(),
              options: [
                SettingsTile.localeChoice(
                  context: context,
                  title: const Text("prefs.language").tr(),
                  leading: const Icon(Icons.language),
                  dialogTitle: "prefs.language".tr(),
                  onChosen: (choice) =>
                      EasyLocalization.of(context)?.setLocale(choice),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
