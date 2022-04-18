import 'dart:math' as math;

extension RoundExt on double {
  int roundToNearestEven() {
    final fraction = this % 1;
    final decimal = (this - fraction).toInt();
    if (fraction < 0.50) return decimal;
    if (fraction > 0.50) return decimal + 1;
    return decimal.isEven ? decimal : decimal + 1;
  }
}

num logBase(num n, num base) {
  return math.log(n) / math.log(base);
}

num pow(int a, int b) => math.pow(a, b);
