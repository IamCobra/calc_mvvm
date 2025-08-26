import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculation.dart';
import '../models/calculator_enums.dart' as enums;
import '../services/calculator_service.dart';

class CalculatorViewState {
  final String display;
  final String expression;
  final String firstNumber;
  final String secondNumber;
  final enums.Operation? selectedOperation;
  final enums.CalculatorState currentState;
  final bool hasError;
  final String errorMessage;

  const CalculatorViewState({
    this.display = '0',
    this.expression = '',
    this.firstNumber = '',
    this.secondNumber = '',
    this.selectedOperation,
    this.currentState = enums.CalculatorState.initial,
    this.hasError = false,
    this.errorMessage = '',
  });

  CalculatorViewState copyWith({
    String? display,
    String? expression,
    String? firstNumber,
    String? secondNumber,
    enums.Operation? selectedOperation,
    enums.CalculatorState? currentState,
    bool? hasError,
    String? errorMessage,
  }) {
    return CalculatorViewState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      firstNumber: firstNumber ?? this.firstNumber,
      secondNumber: secondNumber ?? this.secondNumber,
      selectedOperation: selectedOperation ?? this.selectedOperation,
      currentState: currentState ?? this.currentState,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CalculatorViewModel extends StateNotifier<CalculatorViewState> {
  final CalculatorService _calculatorService;

  CalculatorViewModel(this._calculatorService)
      : super(const CalculatorViewState());

  void inputNumber(String number) {
    if (state.hasError) {
      _resetToInitial();
    }

    switch (state.currentState) {
      case enums.CalculatorState.initial:
      case enums.CalculatorState.result:
        state = state.copyWith(
          display: number == '0' ? '0' : number,
          firstNumber: number,
          currentState: enums.CalculatorState.enteringFirstNumber,
          expression: number,
        );
        break;
      
      case enums.CalculatorState.enteringFirstNumber:
        final newFirstNumber = state.firstNumber + number;
        state = state.copyWith(
          display: newFirstNumber,
          firstNumber: newFirstNumber,
          expression: newFirstNumber,
        );
        break;
      
      case enums.CalculatorState.operationSelected:
        state = state.copyWith(
          display: number,
          secondNumber: number,
          currentState: enums.CalculatorState.enteringSecondNumber,
          expression: _calculatorService.buildExpression(
            state.firstNumber, 
            state.selectedOperation, 
            number
          ),
        );
        break;
      
      case enums.CalculatorState.enteringSecondNumber:
        final newSecondNumber = state.secondNumber + number;
        state = state.copyWith(
          display: newSecondNumber,
          secondNumber: newSecondNumber,
          expression: _calculatorService.buildExpression(
            state.firstNumber, 
            state.selectedOperation, 
            newSecondNumber
          ),
        );
        break;
      
      default:
        break;
    }
  }

  void inputDecimal() {
    if (state.hasError) {
      _resetToInitial();
    }

    String currentNumber = '';
    switch (state.currentState) {
      case enums.CalculatorState.initial:
      case enums.CalculatorState.result:
        state = state.copyWith(
          display: '0.',
          firstNumber: '0.',
          currentState: enums.CalculatorState.enteringFirstNumber,
          expression: '0.',
        );
        return;
      
      case enums.CalculatorState.enteringFirstNumber:
        currentNumber = state.firstNumber;
        break;
      
      case enums.CalculatorState.operationSelected:
        state = state.copyWith(
          display: '0.',
          secondNumber: '0.',
          currentState: enums.CalculatorState.enteringSecondNumber,
          expression: _calculatorService.buildExpression(
            state.firstNumber, 
            state.selectedOperation, 
            '0.'
          ),
        );
        return;
      
      case enums.CalculatorState.enteringSecondNumber:
        currentNumber = state.secondNumber;
        break;
      
      default:
        return;
    }

    if (!currentNumber.contains('.')) {
      if (state.currentState == enums.CalculatorState.enteringFirstNumber) {
        final newFirstNumber = '${state.firstNumber}.';
        state = state.copyWith(
          display: newFirstNumber,
          firstNumber: newFirstNumber,
          expression: newFirstNumber,
        );
      } else if (state.currentState == enums.CalculatorState.enteringSecondNumber) {
        final newSecondNumber = '${state.secondNumber}.';
        state = state.copyWith(
          display: newSecondNumber,
          secondNumber: newSecondNumber,
          expression: _calculatorService.buildExpression(
            state.firstNumber, 
            state.selectedOperation, 
            newSecondNumber
          ),
        );
      }
    }
  }

  void selectOperation(enums.Operation operation) {
    if (state.hasError) {
      _resetToInitial();
      return;
    }

    if (state.currentState == enums.CalculatorState.enteringSecondNumber) {
      // Hvis vi er i gang med at indtaste det andet nummer, udfør beregningen først
      calculate();
    }

    if (state.firstNumber.isNotEmpty) {
      state = state.copyWith(
        selectedOperation: operation,
        currentState: enums.CalculatorState.operationSelected,
        expression: _calculatorService.buildExpression(
          state.firstNumber, 
          operation, 
          ''
        ),
      );
    }
  }

  void calculate() {
    if (state.hasError) {
      _resetToInitial();
      return;
    }

    if (state.firstNumber.isEmpty || 
        state.secondNumber.isEmpty || 
        state.selectedOperation == null) {
      return;
    }

    try {
      final firstNum = double.parse(state.firstNumber);
      final secondNum = double.parse(state.secondNumber);
      
      final result = _calculatorService.performOperation(
        firstNum, 
        secondNum, 
        state.selectedOperation!
      );
      
      final formattedResult = _calculatorService.formatResult(result);
      final expression = _calculatorService.buildExpression(
        state.firstNumber, 
        state.selectedOperation!, 
        state.secondNumber
      );

      // Vis toast for specielle resultater
      if (result == 69 || result == 80085) {
        _showNiceToast();
      }

      state = state.copyWith(
        display: formattedResult,
        expression: '$expression = $formattedResult',
        firstNumber: formattedResult,
        secondNumber: '',
        selectedOperation: null,
        currentState: enums.CalculatorState.result,
      );
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
        display: 'Error',
        currentState: enums.CalculatorState.error,
      );
    }
  }

  void clear() {
    state = const CalculatorViewState();
  }

  void clearEntry() {
    switch (state.currentState) {
      case enums.CalculatorState.enteringFirstNumber:
        state = state.copyWith(
          display: '0',
          firstNumber: '',
          currentState: enums.CalculatorState.initial,
          expression: '',
        );
        break;
      
      case enums.CalculatorState.enteringSecondNumber:
        state = state.copyWith(
          display: '0',
          secondNumber: '',
          currentState: enums.CalculatorState.operationSelected,
          expression: _calculatorService.buildExpression(
            state.firstNumber, 
            state.selectedOperation, 
            ''
          ),
        );
        break;
      
      default:
        clear();
        break;
    }
  }

  void clearHistory() {
    // History functionality removed - method kept for compatibility
  }

  void _resetToInitial() {
    state = const CalculatorViewState();
  }

  void _showNiceToast() {
    // Dette vil blive håndteret i View
  }

  // Getter for at vise velkommen-besked
  String get welcomeMessage {
    if (state.currentState == enums.CalculatorState.initial) {
      return 'Velkommen';
    } else if (state.currentState == enums.CalculatorState.result) {
      return 'Velkommen tilbage';
    }
    return '';
  }
}

// Providers
final calculatorServiceProvider = Provider<CalculatorService>((ref) {
  return CalculatorService();
});

final calculatorViewModelProvider = 
    StateNotifierProvider.family<CalculatorViewModel, CalculatorViewState, String>((ref, sessionId) {
  final calculatorService = ref.watch(calculatorServiceProvider);
  return CalculatorViewModel(calculatorService);
});

// Default provider for backward compatibility
final defaultCalculatorViewModelProvider = 
    StateNotifierProvider<CalculatorViewModel, CalculatorViewState>((ref) {
  final calculatorService = ref.watch(calculatorServiceProvider);
  return CalculatorViewModel(calculatorService);
});
