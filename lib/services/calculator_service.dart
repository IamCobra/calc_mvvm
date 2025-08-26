import '../models/calculator_enums.dart' as enums;

class CalculatorService {
  double performOperation(double firstNumber, double secondNumber, enums.Operation operation) {
    switch (operation) {
      case enums.Operation.add:
        return firstNumber + secondNumber;
      case enums.Operation.subtract:
        return firstNumber - secondNumber;
      case enums.Operation.multiply:
        return firstNumber * secondNumber;
      case enums.Operation.divide:
        if (secondNumber == 0) {
          throw Exception('Division by zero');
        }
        return firstNumber / secondNumber;
      default:
        throw Exception('Unsupported operation');
    }
  }

  String formatResult(double result) {

    
    // hvis vi laver resultat er fx sådan noget som 5.0 så viser vi 5
    if (result == result.roundToDouble()) {
      return result.round().toString();
    }
    
    // ellers vis med passende antal decimaler
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 6)
        .replaceAll(RegExp(r'\.?0+$'), '');
  }

  bool isValidNumber(String input) {
    return double.tryParse(input) != null;
  }

  // hvis resultat er bare 9 så returner vi 9 hvis andet ikke vælges, ellers anvendes 
  String buildExpression(String firstNumber, enums.Operation? operation, String secondNumber) {
    if (operation == null) return firstNumber;
    
    String operatorSymbol = switch (operation) {
      enums.Operation.add => ' + ',
      enums.Operation.subtract => ' - ',
      enums.Operation.multiply => ' × ',
      enums.Operation.divide => ' ÷ ',
      _ => ' = ',
    };
    
    return '$firstNumber$operatorSymbol$secondNumber';
  }
}
