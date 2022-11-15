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

/// Represents a single counter.
class Counter {
  /// Creates a counter with the specified [name].
  Counter(this.name);

  /// Loads a counter from JSON.
  Counter.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        count = json["count"],
        incrementAmount = json["incrementAmount"];

  final id = UniqueKey();

  /// Name of the counter.
  String name;

  /// Current count.
  int count = 0;

  /// Amount to increment/decrement on each click.
  int incrementAmount = 1;

  /// Converts the counter to JSON.
  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "incrementAmount": incrementAmount,
      };

  /// Increments the counter by the specified [incrementAmount].
  void increment() => count += incrementAmount;

  /// Decrements the counter by the specified [incrementAmount].
  void decrement() => count -= incrementAmount;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Counter && id == other.id;
}
