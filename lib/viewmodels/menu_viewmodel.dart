import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculator_session.dart';
import '../services/calculator_session_service.dart';

class MenuViewState {
  final List<CalculatorSession> sessions;
  final bool isLoading;
  final String? errorMessage;

  const MenuViewState({
    this.sessions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MenuViewState copyWith({
    List<CalculatorSession>? sessions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MenuViewState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MenuViewModel extends StateNotifier<MenuViewState> {
  final CalculatorSessionService _sessionService;

  MenuViewModel(this._sessionService) : super(const MenuViewState()) {
    _loadSessions();
  }

  void _loadSessions() {
    state = state.copyWith(
      sessions: _sessionService.sessions,
      isLoading: false,
    );
  }

  CalculatorSession createNewSession() {
    final session = _sessionService.createNewSession();
    state = state.copyWith(
      sessions: _sessionService.sessions,
    );
    return session;
  }

  void updateSessionTitle(String sessionId, String newTitle) {
    _sessionService.updateSessionTitle(sessionId, newTitle);
    state = state.copyWith(
      sessions: _sessionService.sessions,
    );
  }

  void removeSession(String sessionId) {
    _sessionService.removeSession(sessionId);
    state = state.copyWith(
      sessions: _sessionService.sessions,
    );
  }

  void openSession(String sessionId) {
    _sessionService.updateLastUsed(sessionId);
    state = state.copyWith(
      sessions: _sessionService.sessions,
    );
  }

  List<CalculatorSession> get recentSessions {
    return _sessionService.getRecentSessions();
  }

  bool get hasAnySessions => _sessionService.hasAnySessions;
}

// Providers
final sessionServiceProvider = Provider<CalculatorSessionService>((ref) {
  return CalculatorSessionService();
});

final menuViewModelProvider = 
    StateNotifierProvider<MenuViewModel, MenuViewState>((ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  return MenuViewModel(sessionService);
});
