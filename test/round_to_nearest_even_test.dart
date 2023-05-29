import 'package:lexicographical_order/src/math.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('roundToNearestEven()', () {
    test('7.49 => 7', () => expect(7.49.roundToNearestEven(), 7));
    test('7.51 => 8', () => expect(7.51.roundToNearestEven(), 8));
    test('23.5 => 24', () => expect(23.5.roundToNearestEven(), 24));
    test('24.5 => 24', () => expect(24.5.roundToNearestEven(), 24));
    test('25.5 => 26', () => expect(25.5.roundToNearestEven(), 26));
  });
}
