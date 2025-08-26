class Calculation {
  final String expression;
  final double result;
  final DateTime timestamp;

  const Calculation({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  @override
  String toString() {
    return '$expression = $result';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Calculation &&
        other.expression == expression &&
        other.result == result &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(expression, result, timestamp);
}
