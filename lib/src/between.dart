import 'package:lexicographical_order/src/validate.dart';

import './key_space.dart';

/// Get a string between two strings in the lexicographical order.
/// - Constarints
///   - both `prev` and `next` must be composed of alphabets.
///   - `prev.isNotEmpty && next.isNotEmpty`
///   - `prev != null && next != null`
///   - `prev != next`
///   - `prev[prev.length-1] != 'A' && next[next.length-1] != 'A'`
///   - `prev.compareTo(next) == -1`
///
/// The worst-case time compexity is `O(n)` where `n = max(prev.length, next.length) + 1`,
/// but usually, `n` is very short as `between` and `generateOrderKeys` strive to generate
/// a string of as short a length as possible.
///
/// This function does not check the constraints specified above in the release build
/// for performance reasons.
///
/// Example:
/// ```dart
/// final orderKey = between(
///   prev: todos[3].orderKey,
///   next: todos[4].orderKey,
/// );
/// final newTodo = repository.create(command, orderKey);
/// todos.insert(newTodo);
/// ```
String between({String? prev, String? next}) {
  assert(() {
    final validator = const LexOrderValidator();
    validator.checkBetweenArgs(prev: prev, next: next);
    return true;
  }());

  final String prevStr = prev ?? '';
  final String nextStr = next ?? '';
  late int p, n;
  int g = 0;
  String result = '';

  // find the same part.
  while (g == 0 || p == n) {
    p = g < prevStr.length ? keyToIndex[prevStr[g]]! : -1;
    n = g < nextStr.length ? keyToIndex[nextStr[g]]! : keys.length;
    g++;
  }
  result += prevStr.substring(0, g - 1);

  // if prev == next.substrring(0, g)
  if (p == -1) {
    // has A or B
    while (n == 0) {
      n = g < nextStr.length ? keyToIndex[nextStr[g]]! : keys.length;
      result += keys.first;
      g++;
    }
    if (n == 1) {
      result += keys.first;
      n = keys.length;
    }
  } // consecutive
  else if (p == n - 1) {
    result += keys[p];
    n = keys.length;
    p = g < prevStr.length ? keyToIndex[prevStr[g]]! : -1;
    // if prevStr[g] == 'z'
    while (p == keys.length - 1) {
      result += keys.last;
      g++;
      p = g < prevStr.length ? keyToIndex[prevStr[g]]! : -1;
    }
  }

  final median = ((p + n) / 2).ceil();
  result += keys[median];

  return result;
}
