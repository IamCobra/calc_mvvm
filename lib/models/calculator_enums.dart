enum Operation {
  add,
  subtract,
  multiply,
  divide,
  equals,
  clear,
  clearEntry,
  decimal,
}

enum CalculatorState {
  initial,
  enteringFirstNumber,
  operationSelected,
  enteringSecondNumber,
  result,
  error,
}

enum ButtonType {
  number,
  operator,
  function,
  equals,
}
