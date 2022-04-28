import 'package:lexicographical_order/src/key_space.dart';

/// Validator for [between](./between.html) function.
class LexOrderValidator {
  const LexOrderValidator();

  bool isComposedOfAllowedCharacters(String value) {
    if (value.isEmpty) return true;
    for (int i = 0; i < value.length; i++) {
      final ch = value[i];
      if (!keyToIndex.containsKey(ch)) {
        return false;
      }
    }
    return true;
  }

  void checkBetweenArgs({String? prev, String? next}) {
    if (!(isComposedOfAllowedCharacters(prev ?? '') &&
        isComposedOfAllowedCharacters(next ?? ''))) {
      throw ArgumentError(
        'the arguments must be composed of alphabets'
        'but prev == $prev, next == $next',
      );
    }
    if (prev == next) {
      throw ArgumentError(
        'both prev and next but not be equal, '
        'but prev == $prev, next == $next',
      );
    }
    if (prev != null &&
        next != null &&
        prev.isNotEmpty &&
        next.isNotEmpty &&
        prev.compareTo(next) != -1) {
      throw ArgumentError(
        'prev must be ordered befor next, '
        'but prev == $prev, next == $next',
      );
    }
    if (prev != null &&
        prev.isNotEmpty &&
        prev[prev.length - 1] == keys.first) {
      throw ArgumentError(
        'the arguments must not have `A` at the end, '
        'but prev == $prev, next == $next',
      );
    }
    if (next != null &&
        next.isNotEmpty &&
        next[next.length - 1] == keys.first) {
      throw ArgumentError(
        'the arguments must not have `A` at the end, '
        'but prev == $prev, next == $next',
      );
    }
  }
}
