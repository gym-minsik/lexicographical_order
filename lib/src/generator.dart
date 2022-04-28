import './math.dart';
import 'key_space.dart';

List<String> _generateExtraSteps(int count) {
  count %= keys.length;

  final result = <String>[];
  for (int i = 1; i <= count; i++) {
    final index = (keys.length / (count + 1)) * i;
    result.add(keys[index.roundToNearestEven()]);
  }
  return result;
}

/// Permutation with repetition.
/// the stack depth complexity is O(log52 `keyCount`),
/// `keyCount` is the argument of generateOrderKeys(keyCount).
List<String> _generateFoundation(int length) {
  final result = <String>[];

  void dfs(int n, String str) {
    if (n > 0) {
      for (int i = 0; i < keys.length; i++) {
        dfs(n - 1, str + keys[i]);
      }
    } else {
      result.add(str);
    }
  }

  dfs(length, '');
  return result;
}

extension on String {
  String removeTrailings(String trailingCharacter) {
    var last = length - 1;
    while (last >= 0 && this[last] == trailingCharacter) {
      last--;
    }
    return substring(0, last + 1);
  }
}

Iterable<String> _generate(int count) sync* {
  final minLength = logBase(count, keys.length).floor();
  final averageExtraSteps = ((count + 1) / (pow(keys.length, minLength))) - 1.0;
  final stepWeight = averageExtraSteps % 1.0;
  var stepsSelector = 0.5 + stepWeight;

  final a = averageExtraSteps.toInt();
  final extraStepsList = [
    _generateExtraSteps(a),
    _generateExtraSteps(a + 1),
  ];

  for (final f in _generateFoundation(minLength)) {
    yield f.removeTrailings(keys.first);
    yield* extraStepsList[stepsSelector.floor()].map((step) => f + step);

    stepsSelector %= 1;
    stepsSelector += stepWeight;
  }
}

/// Generate strings that satisfy the follwing constraints:
/// 1. the lexicographical order.
/// 2. equally-spaced to use as few additional characters as possible in the future.
///
/// ### How to use?
/// - If you have an ordered database table or collection for which you want to
///   switch to efficient ordered system, generate order keys with this.
/// - For the first order keys, use `generateOrderKeys(orderKeyCount)`.
///
/// Example:
/// ```dart
/// Future<void> addTodo(CreateTodo command) async {
///   final String orderKey = todos.isEmpty
///     ? generateOrderKeys(1).first // <==
///     : between(prev: todos.last.orderKey);
///
///   final todo = await todoRepository.create(command, orderKey);
///   todos.add(todo);
/// }
///```
Iterable<String> generateOrderKeys(int count) sync* {
  if (count <= 0) {
    return;
  } else if (count < keys.length) {
    yield* _generateExtraSteps(count);
  } else {
    yield* _generate(count).skip(1);
  }
}
