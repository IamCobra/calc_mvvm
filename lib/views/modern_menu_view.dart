import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design/app_design.dart';
import '../design/custom_widgets.dart';
import '../models/calculator_session.dart';
import '../viewmodels/menu_viewmodel.dart';
import '../services/toast_service.dart';
import 'modern_calculator_content.dart';

class ModernMenuView extends ConsumerStatefulWidget {
  const ModernMenuView({super.key});

  @override
  ConsumerState<ModernMenuView> createState() => _ModernMenuViewState();
}

class _ModernMenuViewState extends ConsumerState<ModernMenuView> {
  @override
  void initState() {
    super.initState();
    // Vis velkomst toast når app starter fra helt slukket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastService.showWelcomeToast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuViewModelProvider);
    final viewModel = ref.read(menuViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppDesign.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header sektion
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spaceLarge),
              decoration: const BoxDecoration(
                color: AppDesign.surfaceColor,
              ),
              child: Column(
                children: [
                  Text(
                    'Calculator',
                    style: AppDesign.headingLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content sektion
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppDesign.spaceLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ny calculator knap
                    _buildNewCalculatorButton(context, viewModel),
                    
                    const SizedBox(height: AppDesign.spaceLarge),

                    // Sessions header
                    if (state.sessions.isNotEmpty)
                      _buildSectionsHeader(state.sessions.length),

                    // Sessions list
                    Expanded(
                      child: state.sessions.isEmpty
                          ? _buildEmptyState(context)
                          : _buildSessionsList(context, state.sessions, viewModel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCalculatorButton(BuildContext context, MenuViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceMedium),
      child: ElevatedButton(
        onPressed: () => _createNewCalculator(context, viewModel),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.cardColor,
          foregroundColor: AppDesign.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(AppDesign.spaceLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
          ),
        ),
        child: const Text(
          'Ny Calculator',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildSectionsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceMedium),
      child: Text(
        'Sessions ($count)',
        style: AppDesign.headingSmall,
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, List<CalculatorSession> sessions, MenuViewModel viewModel) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(context, session, viewModel);
      },
    );
  }

  Widget _buildSessionCard(BuildContext context, CalculatorSession session, MenuViewModel viewModel) {
    return CustomCard(
      onTap: () => _openCalculator(context, session, viewModel),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: AppDesign.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXSmall),
                Text(
                  'Sidst brugt: ${_formatTime(session.lastUsed)}',
                  style: AppDesign.bodySmall,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppDesign.textMuted,
            ),
            color: AppDesign.cardColor,
            onSelected: (value) {
              switch (value) {
                case 'rename':
                  _showRenameDialog(context, session, viewModel);
                  break;
                case 'delete':
                  _showDeleteConfirmation(context, session, viewModel);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded, color: AppDesign.textSecondary),
                    const SizedBox(width: AppDesign.spaceSmall),
                    Text('Omdøb', style: AppDesign.bodyMedium),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_rounded, color: AppDesign.errorColor),
                    const SizedBox(width: AppDesign.spaceSmall),
                    Text(
                      'Slet', 
                      style: AppDesign.bodyMedium.copyWith(
                        color: AppDesign.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ingen sessioner',
            style: AppDesign.headingSmall.copyWith(
              color: AppDesign.textMuted,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSmall),
          Text(
            'Tryk på "Ny Calculator" for at komme i gang',
            style: AppDesign.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _createNewCalculator(BuildContext context, MenuViewModel viewModel) {
    final session = viewModel.createNewSession();
    _navigateToCalculator(context, session);
  }

  void _openCalculator(BuildContext context, CalculatorSession session, MenuViewModel viewModel) {
    viewModel.openSession(session.id);
    _navigateToCalculator(context, session);
  }

  void _navigateToCalculator(BuildContext context, CalculatorSession session) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            ModernCalculatorWrapper(session: session),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppDesign.animationMedium,
      ),
    );
  }

  void _showRenameDialog(BuildContext context, CalculatorSession session, MenuViewModel viewModel) {
    final controller = TextEditingController(text: session.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesign.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
        ),
        title: Text('Omdøb Session', style: AppDesign.headingSmall),
        content: TextField(
          controller: controller,
          style: AppDesign.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Session navn',
            labelStyle: AppDesign.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
              borderSide: const BorderSide(color: AppDesign.textMuted),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
              borderSide: const BorderSide(color: AppDesign.accentColor),
            ),
          ),
          maxLength: 50,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuller', style: AppDesign.bodyMedium),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                viewModel.updateSessionTitle(session.id, controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppDesign.accentColor,
              foregroundColor: AppDesign.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
              ),
            ),
            child: const Text('Gem'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CalculatorSession session, MenuViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesign.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
        ),
        title: Text('Slet Session', style: AppDesign.headingSmall),
        content: Text(
          'Er du sikker på, at du vil slette "${session.title}"?',
          style: AppDesign.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuller', style: AppDesign.bodyMedium),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.removeSession(session.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppDesign.errorColor,
              foregroundColor: AppDesign.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
              ),
            ),
            child: const Text('Slet'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Lige nu';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m siden';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}t siden';
    } else {
      return '${difference.inDays}d siden';
    }
  }
}

class ModernCalculatorWrapper extends ConsumerWidget {
  final CalculatorSession session;

  const ModernCalculatorWrapper({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(menuViewModelProvider.notifier).openSession(session.id);
      },
      child: Scaffold(
        backgroundColor: AppDesign.backgroundColor,
        appBar: AppBar(
          title: Text(
            session.title,
            style: AppDesign.headingSmall,
          ),
          backgroundColor: AppDesign.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppDesign.textPrimary),
        ),
        body: ModernCalculatorContent(sessionId: session.id),
      ),
    );
  }
}
