# Calculator MVVM

En lommeregner app bygget med Flutter og MVVM (Model-View-ViewModel) arkitektur med multi-session support.

## Arkitektur

Denne app følger MVVM-mønsteret og er organiseret som følger:

### 📁 Mappestruktur

```
lib/
├── main.dart                           # Entry point med ProviderScope
├── models/                             # Data modeller
│   ├── calculation.dart                # Calculation data model
│   ├── calculator_session.dart         # Session model for multi-instance support
│   └── calculator_enums.dart           # Enums for operations og states
├── viewmodels/                         # Business logic & state management
│   ├── calculator_viewmodel.dart       # CalculatorViewModel med Riverpod
│   └── menu_viewmodel.dart             # MenuViewModel for session management
├── views/                              # UI komponenter
│   ├── menu_view.dart                  # Main menu screen
│   ├── calculator_view.dart            # Original calculator screen
│   ├── calculator_content.dart         # Calculator content (reusable)
│   ├── calculator_button.dart          # Reusable button widget
│   └── calculation_history_view.dart   # History bottom sheet
└── services/                           # Business services
    ├── calculator_service.dart         # Calculation logic
    ├── calculation_history_service.dart # History management
    └── calculator_session_service.dart # Session management
```

### 🏛️ MVVM Komponenter

#### **Model**

- `Calculation`: Repræsenterer en beregning med expression, resultat og timestamp
- `CalculatorSession`: Repræsenterer en lommeregner session med ID, titel og timestamps
- `Operation`: Enum for matematik operationer (add, subtract, multiply, divide)
- `CalculatorState`: Enum for calculator states (initial, enteringFirstNumber, etc.)

#### **View**

- `MenuView`: Hovedmenu med session management
- `CalculatorView`: Original calculator screen (backward compatibility)
- `CalculatorContent`: Reusable calculator content component
- `CalculatorButton`: Reusable button component
- `CalculationHistoryView`: Bottom sheet til at vise historik

#### **ViewModel**

- `MenuViewModel`: Håndterer session management og navigation
- `CalculatorViewModel`: Håndterer calculator business logic og state management
- Bruger Riverpod's `StateNotifier` for state management
- Support for multiple session instances via Family providers

#### **Services**

- `CalculatorService`: Udfører matematiske beregninger
- `CalculationHistoryService`: Håndterer beregnings historik
- `CalculatorSessionService`: Håndterer multiple calculator sessioner

## ✨ Features

### 🧮 Calculator Features

- ✅ Grundlæggende matematik operationer (+, -, ×, ÷)
- ✅ Decimaler support
- ✅ Clear og Clear Entry funktionalitet
- ✅ Beregnings historik med timestamp
- ✅ "Nice!" toast for specielle resultater (69, 80085)
- ✅ Velkommen beskeder
- ✅ Fejl håndtering (division by zero)
- ✅ State persistence under navigation
- ✅ Responsive UI design

### 🚀 Multi-Session Features

- ✅ **Hovedmenu** med session oversigt
- ✅ **Opret nye lommeregner sessioner** dynamisk
- ✅ **Multiple aktive sessioner** med separate states
- ✅ **Session management** (omdøb, slet, åbn)
- ✅ **Last used tracking** for sessions
- ✅ **Separate beregningshistorik** per session
- ✅ **Brugervennelig navigation** mellem sessioner
- ✅ **Session persistence** i hukommelsen

## 🛠️ Teknologier

- **Flutter**: UI framework
- **Riverpod**: State management (Provider-based)
- **Dart**: Programming language

## 🎯 MVVM Fordele i denne app

1. **Separation of Concerns**: UI, business logic og data er adskilt
2. **Testability**: Services og ViewModel kan nemt unit testes
3. **Maintainability**: Ændringer i én del påvirker ikke andre dele
4. **Scalability**: Nem at udvide med nye features
5. **State Management**: Centraliseret state gennem Riverpod

## 🚀 Kørsel

```bash
flutter pub get
flutter run
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🧪 Testing

Services og ViewModel er designet til at være nemt testbare:

```dart
// Eksempel på test af CalculatorService
final service = CalculatorService();
final result = service.performOperation(2, 3, Operation.add);
expect(result, equals(5));
```

## 📋 Fremtidige Udvidelser

- [ ] Videnskabelige funktioner
- [ ] Historik persistence
- [ ] Themes support
- [ ] Keyboard shortcuts
- [ ] Unit tests
- [ ] Integration tests
