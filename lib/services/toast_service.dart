import 'package:flutter/material.dart';
import '../design/app_design.dart';

enum ToastType {
  success,
  warning,
  error,
  info,
  nice,
}

class ToastService {
  static OverlayEntry? _currentToast;

  static void showToast(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    // Fjern eksisterende toast
    _currentToast?.remove();

    final overlay = Overlay.of(context);
    
    _currentToast = OverlayEntry(
      builder: (context) => ToastWidget(
        message: message,
        type: type,
        icon: icon,
        onDismiss: () {
          _currentToast?.remove();
          _currentToast = null;
        },
      ),
    );

    overlay.insert(_currentToast!);

    // Auto dismiss
    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }

  static void showNiceToast(BuildContext context) {
    showToast(
      context,
      'Nice!',
      type: ToastType.nice,
      icon: Icons.celebration_rounded,
      duration: const Duration(seconds: 2),
    );
  }

  static void showWelcomeToast(BuildContext context) {
    showToast(
      context,
      'Velkommen!',
      type: ToastType.info,
      icon: Icons.waving_hand_rounded,
    );
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final IconData? icon;
  final VoidCallback onDismiss;

  const ToastWidget({
    super.key,
    required this.message,
    required this.type,
    required this.onDismiss,
    this.icon,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDesign.animationMedium,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -100,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case ToastType.success:
        return AppDesign.successColor;
      case ToastType.warning:
        return AppDesign.warningColor;
      case ToastType.error:
        return AppDesign.errorColor;
      case ToastType.nice:
        return AppDesign.accentColor;
      case ToastType.info:
        return AppDesign.cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceLarge,
                    vertical: AppDesign.spaceMedium,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                    boxShadow: AppDesign.shadowMedium,
                  ),
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: AppDesign.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: AppDesign.spaceMedium),
                      ],
                      Expanded(
                        child: Text(
                          widget.message,
                          style: AppDesign.bodyMedium.copyWith(
                            color: AppDesign.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _animationController.reverse().then((_) {
                            widget.onDismiss();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppDesign.textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
