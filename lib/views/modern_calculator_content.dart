import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design/app_design.dart';
import '../design/custom_widgets.dart';
import '../models/calculator_enums.dart' as enums;
import '../viewmodels/calculator_viewmodel.dart';
import '../viewmodels/menu_viewmodel.dart';
import '../services/toast_service.dart';

class ModernCalculatorContent extends ConsumerStatefulWidget {
  final String sessionId;
  
  const ModernCalculatorContent({super.key, required this.sessionId});

  @override
  ConsumerState<ModernCalculatorContent> createState() => _ModernCalculatorContentState();
}

class _ModernCalculatorContentState extends ConsumerState<ModernCalculatorContent> {
  String? _lastResult;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorViewModelProvider(widget.sessionId));
    final viewModel = ref.read(calculatorViewModelProvider(widget.sessionId).notifier);

    // Vis "Nice!" toast for specielle resultater
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.display != _lastResult && state.display != '0' && state.display != 'Error') {
        _checkForNiceResults(state.display);
        _lastResult = state.display;
      }
    });

    return Container(
      color: AppDesign.backgroundColor,
      child: Column(
        children: [
          // Display sektion
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spaceLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expression display
                  if (state.expression.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDesign.spaceSmall),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          state.expression,
                          style: AppDesign.bodyLarge.copyWith(
                            color: AppDesign.textSecondary,
                          ),
                        ),
                      ),
                    ),

                  // Main display
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          state.display,
                          style: AppDesign.displayText.copyWith(
                            color: state.hasError ? AppDesign.errorColor : AppDesign.textPrimary,
                            fontSize: state.display.length > 10 ? 40 : 56,
                            shadows: [
                              Shadow(
                                color: (state.hasError ? AppDesign.errorColor : AppDesign.accentColor)
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Overførsel knapper - kun vis hvis der er et resultat
                  if (state.display != '0' && !state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppDesign.spaceSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () => _showTransferDialog(context, state.display, viewModel),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text('Overfør'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppDesign.accentColor,
                              backgroundColor: AppDesign.accentColor.withValues(alpha: 0.1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDesign.spaceMedium,
                                vertical: AppDesign.spaceSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Keypad sektion
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(AppDesign.spaceMedium),
              decoration: const BoxDecoration(
                color: AppDesign.surfaceColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDesign.radiusLarge),
                ),
              ),
              child: Column(
                children: [
                  // Første række: AC, ←, %, ÷
                  Expanded(
                    child: Row(
                      children: [
                        CustomButton(
                          text: 'AC',
                          type: enums.ButtonType.function,
                          onPressed: () => viewModel.clear(),
                        ),
                        CustomButton(
                          text: '←',
                          type: enums.ButtonType.function,
                          onPressed: () => viewModel.clearEntry(),
                        ),
                        CustomButton(
                          text: '%',
                          type: enums.ButtonType.operator,
                          onPressed: () {
                            // Implementer procent senere
                          },
                        ),
                        CustomButton(
                          text: '÷',
                          type: enums.ButtonType.operator,
                          onPressed: () => viewModel.selectOperation(enums.Operation.divide),
                        ),
                      ],
                    ),
                  ),

                  // Anden række: 7, 8, 9, ×
                  Expanded(
                    child: Row(
                      children: [
                        CustomButton(
                          text: '7',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('7'),
                        ),
                        CustomButton(
                          text: '8',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('8'),
                        ),
                        CustomButton(
                          text: '9',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('9'),
                        ),
                        CustomButton(
                          text: '×',
                          type: enums.ButtonType.operator,
                          onPressed: () => viewModel.selectOperation(enums.Operation.multiply),
                        ),
                      ],
                    ),
                  ),

                  // Tredje række: 4, 5, 6, -
                  Expanded(
                    child: Row(
                      children: [
                        CustomButton(
                          text: '4',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('4'),
                        ),
                        CustomButton(
                          text: '5',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('5'),
                        ),
                        CustomButton(
                          text: '6',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('6'),
                        ),
                        CustomButton(
                          text: '-',
                          type: enums.ButtonType.operator,
                          onPressed: () => viewModel.selectOperation(enums.Operation.subtract),
                        ),
                      ],
                    ),
                  ),

                  // Fjerde række: 1, 2, 3, +
                  Expanded(
                    child: Row(
                      children: [
                        CustomButton(
                          text: '1',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('1'),
                        ),
                        CustomButton(
                          text: '2',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('2'),
                        ),
                        CustomButton(
                          text: '3',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputNumber('3'),
                        ),
                        CustomButton(
                          text: '+',
                          type: enums.ButtonType.operator,
                          onPressed: () => viewModel.selectOperation(enums.Operation.add),
                        ),
                      ],
                    ),
                  ),

                  // Femte række: 0, ., =
                  Expanded(
                    child: Row(
                      children: [
                        CustomButton(
                          text: '0',
                          type: enums.ButtonType.number,
                          flex: 2,
                          onPressed: () => viewModel.inputNumber('0'),
                        ),
                        CustomButton(
                          text: '.',
                          type: enums.ButtonType.number,
                          onPressed: () => viewModel.inputDecimal(),
                        ),
                        CustomButton(
                          text: '=',
                          type: enums.ButtonType.equals,
                          onPressed: () => viewModel.calculate(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkForNiceResults(String result) {
    // Vis "Nice!" toast for specifikke resultater som er del af opgaven
    if (result == '69' || result == '80085') {
      ToastService.showNiceToast();
    }
  }

  void _showTransferDialog(BuildContext context, String result, CalculatorViewModel currentViewModel) {
    final sessions = ref.read(menuViewModelProvider).sessions;
    
    // Filtrér væk den nuværende session
    final otherSessions = sessions.where((s) => s.id != widget.sessionId).toList();
    
    if (otherSessions.isEmpty) {
      // Ingen andre sessions tilgængelige - gør intet
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesign.cardColor,
        title: Text(
          'Overfør resultat: $result',
          style: AppDesign.headingSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vælg hvilken session du vil overføre resultatet til:',
              style: AppDesign.bodyMedium,
            ),
            const SizedBox(height: AppDesign.spaceMedium),
            ...otherSessions.map((session) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(session.title, style: AppDesign.bodyLarge),
              subtitle: Text('Sidst brugt: ${_formatSessionTime(session.lastUsed)}'),
              onTap: () {
                Navigator.pop(context);
                _transferToSession(session.id, result);
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuller'),
          ),
        ],
      ),
    );
  }

  void _transferToSession(String sessionId, String result) {
    // Hent den anden session's view model
    final targetViewModel = ref.read(calculatorViewModelProvider(sessionId).notifier);
    
    // Indsæt resultatet som input i den anden session
    targetViewModel.clear();
    targetViewModel.inputNumber(result);
  }

  String _formatSessionTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Lige nu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m siden';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}t siden';
    } else {
      return '${difference.inDays}d siden';
    }
  }
}
