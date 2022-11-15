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

import '../models/counter.dart';
import 'counter_dialog.dart';

class CounterWidget extends StatefulWidget {
  /// Duration of the insertion/deletion of a counter
  static const animationDuration = Duration(milliseconds: 400);

  const CounterWidget({
    super.key,
    required this.counter,
    required this.listController,
    this.showDelete = true,
    this.compact = false,
    this.onDeleted,
    this.onChanged,
  });

  final Counter counter;
  final AnimatedListController listController;
  final bool showDelete;
  final bool compact;
  final Function? onDeleted;
  final Function? onChanged;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    final double incDecButtonsPadding = widget.compact ? 20 : 24;

    return Card(
      margin: EdgeInsets.all(widget.compact ? 2 : 4),
      elevation: widget.compact ? 1 : 2,
      child: Padding(
        padding: EdgeInsets.all(widget.compact ? 0 : 5),
        child: Row(
          children: [
            // Decrement button
            CircleButton(
              onPressed: _decrement,
              icon: Icons.remove,
              padding: incDecButtonsPadding,
              tooltip: "decrementBy"
                  .tr(args: [widget.counter.incrementAmount.toString()]),
              color: Colors.white,
              backgroundColor: Colors.red,
            ),
            Expanded(
              child: Column(
                children: [
                  // Counter name (normal mode)
                  if (!widget.compact)
                    Text(
                      widget.counter.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  // Counter name and actions (compact mode)
                  if (widget.compact)
                    _buildActionButtons(context, name: widget.counter.name),
                  // Current count
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.compact ? 4 : 0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: Text(
                        widget.counter.count.toString(),
                        // So the AnimatedSwitcher animates when the count changes
                        key: ValueKey(widget.counter.count),
                        style: TextStyle(
                          fontSize: widget.compact ? 20 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Actions (normal mode)
                  if (!widget.compact) _buildActionButtons(context),
                ],
              ),
            ),
            // Increment button
            CircleButton(
              onPressed: _increment,
              icon: Icons.add,
              padding: incDecButtonsPadding,
              tooltip: "incrementBy"
                  .tr(args: [widget.counter.incrementAmount.toString()]),
              color: Colors.white,
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, {String? name}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 240 && !widget.compact) {
          // Show all actions as buttons
          return _buildActionButtonsWide(context);
        } else {
          // Show the actions inside a popup menu
          return _buildActionButtonsNarrow(context, name: name);
        }
      },
    );
  }

  Widget _buildActionButtonsWide(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.all(0),
      children: [
        // Edit button
        TextButton(
          onPressed: _edit,
          child: const Text("edit").tr(),
        ),
        // Reset button
        TextButton(
          onPressed: _reset,
          child: const Text("reset").tr(),
        ),
        // Delete button
        if (widget.showDelete)
          TextButton(
            onPressed: _delete,
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(context.theme.errorColor),
            ),
            child: const Text("delete").tr(),
          ),
      ],
    );
  }

  Widget _buildActionButtonsNarrow(BuildContext context, {String? name}) {
    return PopupMenuButton(
      // AbsorbPointer, so that the TextButton doesn't steal the click from the PopupMenuButton
      child: AbsorbPointer(
        child: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  name ?? "actions".tr(),
                  style: TextStyle(fontSize: widget.compact ? 12 : 14),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: widget.compact ? 20 : null,
              ),
            ],
          ),
          onPressed: () {},
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          // Call the method on next frame, so the dialog isn't closed immediately
          onTap: () => onNextFrame((_) => _edit()),
          child: const Text("edit").tr(),
        ),
        PopupMenuItem(
          onTap: _reset,
          child: const Text("reset").tr(),
        ),
        if (widget.showDelete)
          PopupMenuItem(
            onTap: _delete,
            child: const Text("delete").tr(),
          ),
      ],
    );
  }

  void _increment() {
    setState(() {
      widget.counter.increment();
    });
    widget.onChanged?.call();
  }

  void _decrement() {
    setState(() {
      widget.counter.decrement();
    });
    widget.onChanged?.call();
  }

  void _reset() {
    if (widget.counter.count != 0) {
      // Reset the count (but remember the original so the user can undo it)
      final originalCount = widget.counter.count;
      setState(() {
        widget.counter.count = 0;
      });
      widget.onChanged?.call();

      // Show a snack bar with an option to revert the reset
      context.showSnackBarMessage(
        "wasReset".tr(args: [widget.counter.name]),
        actionLabel: "undo".tr(),
        actionOnPressed: () => setState(() {
          widget.counter.count = originalCount;
          widget.onChanged?.call();
        }),
      );
    }
  }

  void _edit() async {
    var res = await showCounterDialog(context, widget.counter);
    if (res != null) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  void _delete() async {
    // Hide the item (with animation), then call the callback
    await widget.listController.hide(widget.counter);
    widget.onDeleted?.call();
  }
}
