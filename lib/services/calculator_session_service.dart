import '../models/calculator_session.dart';

class CalculatorSessionService {
  final List<CalculatorSession> _sessions = [];
  int _sessionCounter = 1;

  List<CalculatorSession> get sessions => List.unmodifiable(_sessions);

  CalculatorSession createNewSession() {
    final session = CalculatorSession(
      id: 'calc_$_sessionCounter',
      title: 'Lommeregner $_sessionCounter',
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
    );
    
    _sessions.add(session);
    _sessionCounter++;
    return session;
  }

  void updateSessionTitle(String sessionId, String newTitle) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(
        title: newTitle,
        lastUsed: DateTime.now(),
      );
    }
  }

  void updateLastUsed(String sessionId) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(
        lastUsed: DateTime.now(),
      );
    }
  }

  void removeSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);
  }

  CalculatorSession? getSession(String sessionId) {
    try {
      return _sessions.firstWhere((s) => s.id == sessionId);
    } catch (e) {
      return null;
    }
  }

  List<CalculatorSession> getRecentSessions({int limit = 5}) {
    final sortedSessions = List<CalculatorSession>.from(_sessions);
    sortedSessions.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    return sortedSessions.take(limit).toList();
  }

  bool get hasAnySessions => _sessions.isNotEmpty;

  int get sessionCount => _sessions.length;
}
