import 'package:lexicographical_order/src/validate.dart';
import 'package:test/test.dart';
import 'package:lexicographical_order/lexicographical_order.dart';

void main() {
  group('between(...)', () {
    _basicCase();
    _consecutive();
    _hasAorB();
    _testWithNullArgs();
    _exceptionCase();
  });
}

/// Test the basic case.
/// the algorithm start by copying the characters until you encounter
/// the first difference, which could be two cases.
/// * case 1: Two different characters meet.
///   [ABCdE | ABChi => ABC + dE | ABC + hi]
///   In this case, the new string between the two strings, 'ABCdE' and 'ABChi'
///   in the lexicographical order, has a leading string 'ABC'.
///   and then the next character uses an intermediate string between 'd' and 'h'.
///   so the total string is 'ABCf' = 'ABC' + ('d'+'h')/2
/// * case 2: the prev string ends
///   ABC | ABCgi => ABC | ABC + gi
///   similarly, [ABC | ABCgi => ABC | ABC + gi]
///   the new string is ABCQ = ABC + ('A' + 'g')/2
void _basicCase() {
  test('Basic case #1', () {
    const prev = 'ABCdE';
    const next = 'ABChi';
    final result = between(prev: prev, next: next);

    expect(result, 'ABCf');
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('Basic case #2', () {
    const prev = 'ABC';
    const next = 'ABCgi';
    final result = between(prev: prev, next: next);

    expect(result, 'ABCQ');
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
}

void _consecutive() {
  test('Consecutive case #1', () {
    const prev = 'ABHe';
    const next = 'ABIn';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('Consecutive case #2', () {
    const prev = 'ABH';
    const next = 'ABIw';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('Consecutive case #3', () {
    const prev = 'ABHz';
    const next = 'ABIn';
    final result = between(prev: prev, next: next);
    expect(result, 'ABHza');
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
}

void _hasAorB() {
  const prev = 'ABC';
  test('AorB case #1', () {
    const next = 'ABCAH';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('AorB case #2', () {
    const next = 'ABCAB';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('AorB case #3', () {
    const next = 'ABCAAh';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
  });
  test('AorB case #4', () {
    const next = 'ABCB';
    final result = between(prev: prev, next: next);
    expect([result, next, prev]..sort(), [prev, result, next]);
    expect(result, 'ABCAa');
  });
}

void _testWithNullArgs() {
  test('prev is null', () {
    const next = 'ahd';
    final prev = between(next: next);
    final pprev = between(next: prev);
    expect([next, pprev, prev]..sort(), [pprev, prev, next]);
  });

  test('next is null', () {
    const prev = 'abd';
    final next = between(prev: prev);
    final nnext = between(prev: next);
    expect([nnext, prev, next]..sort(), [prev, next, nnext]);
  });
}

void _exceptionCase() {
  test('should throw ArgumentError WHEN non-alphabet string was passed. #1',
      () {
    const prev = 'A';
    const next = '*%ABc';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN non-alphabet string was passed. #2',
      () {
    const next = '*%1c';
    const prev = 'Hji';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN non-alphabet string was passed. #3',
      () {
    const next = '*%1c';
    const prev = '(&ZC3&';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN empty strings were passed. #1', () {
    expect(
      () => between(prev: '', next: ''),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN empty strings were passed. #2', () {
    expect(
      () => between(),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN same strings were passed.', () {
    const prev = 'GH';
    const next = 'GH';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
  test(
      'should throw ArgumentError WHEN a string containing `A` at the end was passed. #1',
      () {
    const prev = 'GH';
    const next = 'GHA';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
  test(
      'should throw ArgumentError WHEN a string containing `A` at the end was passed. #2',
      () {
    expect(
      () => between(prev: '', next: 'A'),
      throwsA(isArgumentError),
    );
  });
  test(
      'should throw ArgumentError WHEN a string containing `A` at the end was passed. #3',
      () {
    expect(
      () => between(prev: 'ABC', next: 'ABCAA'),
      throwsA(isArgumentError),
    );
  });

  test(
      'should throw ArgumentError WHEN a string containing `A` at the end was passed. #4',
      () {
    expect(
      () => between(prev: 'HzA', next: 'Ix'),
      throwsA(isArgumentError),
    );
  });
  test('should throw ArgumentError WHEN prev is ordered after next.', () {
    const prev = 'D';
    const next = 'B';
    expect(
      () => between(prev: prev, next: next),
      throwsA(isArgumentError),
    );
  });
}
