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

/// Generates strings that satisfy the following constraints:
/// 1. They adhere to lexicographical order.
/// 2. They are equally spaced to minimize the need for additional characters in the future.
///
/// ### How to use?
/// - If you have an ordered database table or collection and you want to
///   switch to an efficient ordering system, use this function to generate order keys.
/// - For the initial set of order keys, use `generateOrderKeys(orderKeyCount)`.
///
/// Example:
/// ```dart
/// Future<void> addTodo(CreateTodo command) async {
///   final String orderKey = todos.isEmpty
///     ? generateOrderKeys(1).first // Use this when the todo list is empty.
///     : between(prev: todos.last.orderKey); // Use this when adding to an existing list.
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
