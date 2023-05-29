import 'package:lexicographical_order/src/validate.dart';

import './key_space.dart';

/// Generates a lexicographically ordered string between A and B.
///
/// The worst-case time complexity is `O(n)`, where `n` is the maximum length of `prev` and `next` plus 1.
/// However, `n` is usually very short, and thus acceptable for production environments.
///
/// Constraints:
///   - Both `prev` and `next` must be composed of alphabets.
///   - `prev` and `next` must not be null or empty.
///   - `prev` and `next` must not be the same.
///   - The last character of `prev` must not be 'A', and the last character of `next` must not be 'A'.
///   - Lexicographically, `prev` must be less than `next` (i.e., `prev.compareTo(next) == -1`).
///
/// For performance reasons, it does not check the constraints specified above in the release build.
/// However, you can manually verify these constraints using the `LexOrderValidator.checkBetweenArgs` method.
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
