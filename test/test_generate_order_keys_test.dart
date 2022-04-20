import 'package:lexicographical_order/lexicographical_order.dart';
import 'package:test/test.dart';

void main() {
  group('generateOrderKeys', () {
    _testNotPositiveKeyCount();
    _testGeneratedKeysShouldBeSorted();
  });
}

void _testNotPositiveKeyCount() {
  test('should return empty list if keyCount <= 0', () {
    for (int i = 0; i >= -10; i--) {
      final result = generateOrderKeys(i).toList();
      const expected = <String>[];
      expect(result, expected);
    }
  });
}

void _testGeneratedKeysShouldBeSorted() {
  test('should return a sorted list in a lexicographical order', () {
    for (int keyCount = 1; keyCount <= 2600; keyCount++) {
      final result = generateOrderKeys(keyCount).toList(growable: false);
      final copyAndSorted = [...result]..sort();

      expect(keyCount, result.length);
      expect(result.every((e) => e.isNotEmpty), true);
      expect(result, copyAndSorted);
    }

    const bigKeyCounts = [
      10000,
      20000,
      30000,
      40000,
      50000,
      60000,
      70000,
      80000,
      90000,
      100000
    ];

    for (final keyCount in bigKeyCounts) {
      final result = generateOrderKeys(keyCount).toList(growable: false);
      final copyAndSorted = [...result]..sort();

      expect(keyCount, result.length);
      expect(result.every((e) => e.isNotEmpty), true);
      expect(result, copyAndSorted);
    }
  });
}
