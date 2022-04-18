import 'package:test/test.dart';
import '../lib/src/key_space.dart';

void testKeySpace() {
  group('key_space', () {
    test("'keys' should be sorted", () {
      expect(keys, List.of(keys, growable: false)..sort());
    });
    test(
        "'keyToIndex' should correctly contain the information about 'keySpace'",
        () {
      expect(keyToIndex.keys.toList(growable: false), keys);

      for (final entry in keyToIndex.entries) {
        expect(keys[entry.value], entry.key);
      }
    });
  });
}
