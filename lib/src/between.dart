import 'package:lexicographical_order/src/validate.dart';

import './key_space.dart';

/// Get a string between two strings in a lexicographical order.
/// - Constarints
///   allowed character = ABCDEFGHIJKLMNOPQRSTUWXYZabcdefghijklmnopqrstuwxyz
///   - prev and next should consist only of allowed characters.
///   - prev and next shouldn't be equal to each other
///   - prev should not precede next in a lexicographical order
///
/// This function does not check the constraints specified above in the release build
/// for performance reasons.
String between({String? prev, String? next}) {
  assert(() {
    final validator = const LexOrderValidator();
    validator.checkBetweenArgs(prev: prev, next: next);
    return true;
  }());

  final String prevStr = prev ?? '';
  final String nextStr = next ?? '';

  late int _prev, _next;
  int pos = 0;
  String str;
  for (; pos == 0 || _prev == _next; pos++) {
    _prev = pos < prevStr.length ? keyToIndex[prevStr[pos]]! : -1;
    _next =
        pos < nextStr.length ? keyToIndex[nextStr[pos]]! : keyToIndex.length;
  }
  str = prevStr.substring(0, pos - 1);
  if (_prev == -1) {
    while (_next == 0) {
      _next = pos < nextStr.length
          ? keyToIndex[nextStr[pos++]]!
          : keyToIndex.length;
      str += keys.first;
    }
    if (_next == 1) {
      str += keys.first;
      _next = keyToIndex.length;
    }
  } else if (_prev + 1 == _next) {
    str += keys[_prev];
    _next = keyToIndex.length;
    while ((_prev = pos < prevStr.length ? keyToIndex[prevStr[pos++]]! : -1) ==
        keyToIndex.length - 1) {
      str += keys.last;
    }
  }
  return str + keys[((_prev + _next) / 2).ceil()];
}
