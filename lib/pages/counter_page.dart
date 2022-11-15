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
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_common/material.dart';

import '../models/counter.dart';
import '../notifiers/theme_prefs.dart';
import '../widgets/counter_dialog.dart';
import '../widgets/counter_widget.dart';
import '../widgets/scaffold.dart';

class CounterPage extends StatefulWidget {
  /// Path of this page for navigation
  static const path = "/";

  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final _scrollController = ScrollController();
  final _counters = List<Counter>.empty(growable: true);
  late final AnimatedListController<Counter> _listController;

  @override
  void initState() {
    super.initState();
    _loadCounters();
    _listController = AnimatedListController(_counters);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "${'counters'.tr()} - ${'appName'.tr()}",
      appBar: AppBar(
        title: const Text("counters").tr(),
      ),
      body: Consumer<ThemePrefs>(
        builder: (context, themePrefs, child) =>
            AnimatedReorderableListView<Counter>(
          controller: _listController,
          scrollController: _scrollController,
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 100),
          buildDefaultDragHandles: false,
          onReorder: _onMoveCounter,
          animationDuration: CounterWidget.animationDuration,
          animationCurve: Curves.easeInOut,
          buildItem: (counter, index) => CounterWidget(
            key: counter.id,
            counter: counter,
            listController: _listController,
            showDelete: _counters.length > 1,
            compact: themePrefs.compactMode,
            onDeleted: () => _deleteCounter(context, counter),
            onChanged: () => _saveCounters(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newCounter,
        label: const Text("addCounter").tr(),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Load the counters
  void _loadCounters() {
    try {
      final savedCounters = App.prefs.getStringList("counters");
      if (savedCounters != null) {
        _counters.addAll([
          for (var counter in savedCounters)
            Counter.fromJson(jsonDecode(counter))
        ]);
      } else {
        // No counters yet. Add the first counter
        _counters.add(Counter("counter".tr()));
        _saveCounters();
      }
    } catch (e) {
      // Error. Add a single counter
      log("Error loading counters!", error: e);
      _counters.add(Counter("counter".tr()));
      _saveCounters();
      if (mounted) {
        context.showSnackBarMessage("errorLoadingCounters".tr());
      }
    }
  }

  /// Save the counters
  void _saveCounters() {
    App.prefs.setStringList(
        "counters", [for (var counter in _counters) jsonEncode(counter)]);
  }

  /// Creates a new counter
  void _newCounter() async {
    var counter = await showCounterDialog(context);
    if (counter != null) {
      setState(() {
        _counters.add(counter);
      });
      _saveCounters();

      if (_counters.length == 2 && mounted) {
        context.showSnackBarMessage("canDragCounters".tr());
      }

      // Scroll the list view to the bottom after the animation ends
      Future.delayed(CounterWidget.animationDuration, () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      });
    }
  }

  /// Deletes the given counter
  void _deleteCounter(BuildContext context, Counter counter) async {
    // Find the index of the counter
    int index = _counters.indexOf(counter);
    assert(index >= 0);

    // Delete it
    setState(() {
      _counters.removeAt(index);
    });
    _saveCounters();

    // Show a snack bar with an option to revert the deletion
    context.showSnackBarMessage(
      "deleted".tr(args: [counter.name]),
      actionLabel: "undo".tr(),
      actionOnPressed: () => setState(() {
        _counters.insert(index, counter);
        _saveCounters();
      }),
    );
  }

  void _onMoveCounter(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      Counter counter = _counters.removeAt(oldIndex);
      _counters.insert(newIndex, counter);
    });
    _saveCounters();
  }
}
