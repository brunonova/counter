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

import '../widgets/scaffold.dart';

class AboutPage extends StatelessWidget {
  /// Path of this page for navigation
  static const path = "/about";

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "${'about'.tr()} - ${'appName'.tr()}",
      appBar: AppBar(
        title: const Text("about").tr(),
      ),
      body: const AboutInfo(authors: ["Bruno Nova"]),
    );
  }
}
