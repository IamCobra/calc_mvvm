import 'package:flutter/material.dart';
import '../design/app_design.dart';
import '../models/calculator_enums.dart' as enums;

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final enums.ButtonType type;
  final int flex;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = enums.ButtonType.number,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 64,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _backgroundColor,
            foregroundColor: AppDesign.textPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
            ),
          ),
          child: Text(
            text,
            style: AppDesign.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case enums.ButtonType.number:
        return AppDesign.numberButtonColor;
      case enums.ButtonType.operator:
        return AppDesign.operatorButtonColor;
      case enums.ButtonType.function:
        return AppDesign.functionButtonColor;
      case enums.ButtonType.equals:
        return AppDesign.operatorButtonColor;
    }
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceMedium,
        vertical: AppDesign.spaceSmall,
      ),
      child: Material(
        color: AppDesign.cardColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDesign.spaceLarge),
            child: child,
          ),
        ),
      ),
    );
  }
}
