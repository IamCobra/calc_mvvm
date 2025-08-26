class CalculatorSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastUsed;

  const CalculatorSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastUsed,
  });

  CalculatorSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) {
    return CalculatorSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalculatorSession &&
        other.id == id &&
        other.title == title &&
        other.createdAt == createdAt &&
        other.lastUsed == lastUsed;
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, lastUsed);

  @override
  String toString() {
    return 'CalculatorSession(id: $id, title: $title)';
  }
}
