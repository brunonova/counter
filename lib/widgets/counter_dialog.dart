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

import '../models/counter.dart';

/// Show the dialog to create or edit a counter.
Future<Counter?> showCounterDialog(BuildContext context,
    [Counter? counter]) async {
  return await showDialog(
    context: context,
    builder: (context) => CounterDialog(counter: counter),
  );
}

class CounterDialog extends StatefulWidget {
  const CounterDialog({super.key, this.counter});

  /// The counter.
  final Counter? counter;

  @override
  State<CounterDialog> createState() => _CounterDialogState();
}

class _CounterDialogState extends State<CounterDialog> {
  late bool isNewCounter;
  late Counter counter;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  final _incrementAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isNewCounter = widget.counter == null;
    counter = isNewCounter ? Counter("") : widget.counter!;

    _nameController.text = counter.name;
    _countController.text = counter.count.toString();
    _incrementAmountController.text = counter.incrementAmount.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _countController.dispose();
    _incrementAmountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNewCounter ? "newCounter" : "editCounter").tr(),
      scrollable: true,
      insetPadding: CommonConstants.dialogInsetPadding,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Counter name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "name".tr()),
              onFieldSubmitted: (_) => _save(),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "requiredField".tr();
                }
                return null;
              },
            ),
            // Initial/current count
            TextFormField(
              controller: _countController,
              decoration: InputDecoration(
                  labelText:
                      tr(isNewCounter ? "initialCount" : "currentCount")),
              onFieldSubmitted: (_) => _save(),
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "requiredField".tr();
                }
                return null;
              },
            ),
            // Increment amount
            TextFormField(
              controller: _incrementAmountController,
              decoration: InputDecoration(labelText: "incrementAmount".tr()),
              onFieldSubmitted: (_) => _save(),
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "requiredField".tr();
                }
                if (int.parse(value) <= 0) {
                  return "mustBePositive".tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.navigator.pop(),
          child: const Text("cancel").tr(),
        ),
        TextButton(
          onPressed: _save,
          child: const Text("ok").tr(),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      counter.name = _nameController.text;
      counter.count = int.parse(_countController.text);
      counter.incrementAmount = int.parse(_incrementAmountController.text);
      context.navigator.pop(counter);
    }
  }
}
