import 'package:flutter/material.dart';

// Vores eget minimalistiske design system
class AppDesign {
  // Simple brand farver
  static const Color primaryColor = Color(0xFF1F2937);
  static const Color secondaryColor = Color(0xFF374151);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  
  // Minimale neutral farver
  static const Color backgroundColor = Color(0xFF111827);
  static const Color surfaceColor = Color(0xFF1F2937);
  static const Color cardColor = Color(0xFF374151);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textMuted = Color(0xFF9CA3AF);
  
  // Calculator specifikke farver - minimale
  static const Color displayBackground = Color(0xFF111827);
  static const Color buttonBackground = Color(0xFF374151);
  static const Color numberButtonColor = Color(0xFF1F2937);
  static const Color operatorButtonColor = Color(0xFF3B82F6);
  static const Color functionButtonColor = Color(0xFF6B7280);
  
  // Mindre border radius for cleaner look
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  
  // Spacing
  static const double spaceXSmall = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceXLarge = 32.0;
  static const double spaceXXLarge = 48.0;
  
  // Typography - mere minimalistisk
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textMuted,
  );
  
  static const TextStyle displayText = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w300,
    color: textPrimary,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
  
  // Subtile shadows
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
