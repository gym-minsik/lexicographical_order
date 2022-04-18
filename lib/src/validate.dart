import 'package:lexicographical_order/src/key_space.dart';

/// Validator for [between](./between.html) function
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
    if (!isComposedOfAllowedCharacters(prev ?? '')) {
      throw NotComposedOfAllowedCharactersError(prev!);
    }
    if (!isComposedOfAllowedCharacters(next ?? '')) {
      throw NotComposedOfAllowedCharactersError(next!);
    }
    if (next == keys.first) throw NextMustNotBeForemostCharacterError(next!);
    if (prev == next) {
      throw PrevAndNextMustNotBeEqualError(prev: prev, next: next);
    }
    if (prev != null &&
        next != null &&
        prev.isNotEmpty &&
        next.isNotEmpty &&
        prev.compareTo(next) != -1) {
      throw PrevCannotSucceedNextError(prev: prev, next: next);
    }
  }
}

class NotComposedOfAllowedCharactersError extends Error {
  final String argument;

  NotComposedOfAllowedCharactersError(this.argument);

  @override
  String toString() {
    return "You've passed the invalid argument('$argument) composed of disallowed characters."
        " an argument must be composed of alphabets.";
  }
}

class NextMustNotBeForemostCharacterError extends Error {
  final String argument;

  NextMustNotBeForemostCharacterError(this.argument);

  @override
  String toString() {
    return "'next' parameter must not be 'A' because no characters can precede 'A'.";
  }
}

class PrevAndNextMustNotBeEqualError extends Error {
  final String? prev;
  final String? next;
  PrevAndNextMustNotBeEqualError({
    required this.prev,
    required this.next,
  });

  @override
  String toString() {
    return "prev and next must not be equal. but prev($prev) and next($next) passed.";
  }
}

class PrevCannotSucceedNextError extends Error {
  final String prev;
  final String next;
  PrevCannotSucceedNextError({
    required this.prev,
    required this.next,
  });

  @override
  String toString() {
    return "prev can't succeed next in a lexicographical order. but prev($prev) and next($next) passed";
  }
}
