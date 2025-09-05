import 'package:flutter/material.dart';

/// Custom theme extension for cosmic/space-themed colors and gradients
@immutable
class CosmicThemeExtension extends ThemeExtension<CosmicThemeExtension> {
  const CosmicThemeExtension({
    required this.cosmicGradient,
    required this.nightSkyGradient,
    required this.stardustGradient,
    required this.categoryColors,
    required this.statusColors,
    required this.socialColors,
  });

  final LinearGradient cosmicGradient;
  final LinearGradient nightSkyGradient;
  final LinearGradient stardustGradient;
  final Map<String, Color> categoryColors;
  final Map<String, Color> statusColors;
  final Map<String, Color> socialColors;

  @override
  CosmicThemeExtension copyWith({
    LinearGradient? cosmicGradient,
    LinearGradient? nightSkyGradient,
    LinearGradient? stardustGradient,
    Map<String, Color>? categoryColors,
    Map<String, Color>? statusColors,
    Map<String, Color>? socialColors,
  }) {
    return CosmicThemeExtension(
      cosmicGradient: cosmicGradient ?? this.cosmicGradient,
      nightSkyGradient: nightSkyGradient ?? this.nightSkyGradient,
      stardustGradient: stardustGradient ?? this.stardustGradient,
      categoryColors: categoryColors ?? this.categoryColors,
      statusColors: statusColors ?? this.statusColors,
      socialColors: socialColors ?? this.socialColors,
    );
  }

  @override
  CosmicThemeExtension lerp(ThemeExtension<CosmicThemeExtension>? other, double t) {
    if (other is! CosmicThemeExtension) {
      return this;
    }
    return CosmicThemeExtension(
      cosmicGradient: LinearGradient.lerp(cosmicGradient, other.cosmicGradient, t)!,
      nightSkyGradient: LinearGradient.lerp(nightSkyGradient, other.nightSkyGradient, t)!,
      stardustGradient: LinearGradient.lerp(stardustGradient, other.stardustGradient, t)!,
      categoryColors: _lerpColorMap(categoryColors, other.categoryColors, t),
      statusColors: _lerpColorMap(statusColors, other.statusColors, t),
      socialColors: _lerpColorMap(socialColors, other.socialColors, t),
    );
  }

  Map<String, Color> _lerpColorMap(Map<String, Color> a, Map<String, Color> b, double t) {
    final keys = {...a.keys, ...b.keys};
    return Map.fromEntries(
      keys.map((key) {
        final colorA = a[key] ?? Colors.transparent;
        final colorB = b[key] ?? Colors.transparent;
        return MapEntry(key, Color.lerp(colorA, colorB, t)!);
      }),
    );
  }

  // Light theme extension
  static const light = CosmicThemeExtension(
    cosmicGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4B5B8B), Color(0xFF789AD9), Color(0xFFA2C7E7)],
      stops: [0.0, 0.5, 1.0],
    ),
    nightSkyGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A202D), Color(0xFF4B5B8B)],
      stops: [0.0, 1.0],
    ),
    stardustGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF789AD9), Color(0xFFA2C7E7), Color(0xFFF5FAFF)],
      stops: [0.0, 0.7, 1.0],
    ),
    categoryColors: {
      'astronomy': Color(0xFF6366F1),
      'physics': Color(0xFF8B5CF6),
      'chemistry': Color(0xFF06B6D4),
      'space_exploration': Color(0xFF10B981),
      'cosmology': Color(0xFFE11D48),
      'astrophysics': Color(0xFFF59E0B),
      'particle_physics': Color(0xFF84CC16),
      'quantum_mechanics': Color(0xFF3B82F6),
      'general_science': Color(0xFF6B7280),
    },
    statusColors: {
      'online': Color(0xFF10B981),
      'offline': Color(0xFF6B7280),
      'draft': Color(0xFFF59E0B),
      'published': Color(0xFF10B981),
      'archived': Color(0xFF6B7280),
    },
    socialColors: {
      'facebook': Color(0xFF1877F2),
      'twitter': Color(0xFF1DA1F2),
      'linkedin': Color(0xFF0A66C2),
      'instagram': Color(0xFFE4405F),
      'youtube': Color(0xFFFF0000),
      'github': Color(0xFF24292E),
    },
  );

  // Dark theme extension
  static const dark = CosmicThemeExtension(
    cosmicGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF789AD9), Color(0xFFA2C7E7), Color(0xFF4B5B8B)],
      stops: [0.0, 0.5, 1.0],
    ),
    nightSkyGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0F0F1A), Color(0xFF1A202D)],
      stops: [0.0, 1.0],
    ),
    stardustGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1A202D), Color(0xFF4B5B8B), Color(0xFF789AD9)],
      stops: [0.0, 0.5, 1.0],
    ),
    categoryColors: {
      'astronomy': Color(0xFF7C3AED),
      'physics': Color(0xFFA855F7),
      'chemistry': Color(0xFF0891B2),
      'space_exploration': Color(0xFF059669),
      'cosmology': Color(0xFFBE185D),
      'astrophysics': Color(0xFFD97706),
      'particle_physics': Color(0xFF65A30D),
      'quantum_mechanics': Color(0xFF2563EB),
      'general_science': Color(0xFF4B5563),
    },
    statusColors: {
      'online': Color(0xFF10B981),
      'offline': Color(0xFF6B7280),
      'draft': Color(0xFFF59E0B),
      'published': Color(0xFF10B981),
      'archived': Color(0xFF6B7280),
    },
    socialColors: {
      'facebook': Color(0xFF1877F2),
      'twitter': Color(0xFF1DA1F2),
      'linkedin': Color(0xFF0A66C2),
      'instagram': Color(0xFFE4405F),
      'youtube': Color(0xFFFF0000),
      'github': Color(0xFF24292E),
    },
  );
}

/// Extension to easily access cosmic theme from BuildContext
extension CosmicThemeExtensionContext on BuildContext {
  CosmicThemeExtension get cosmic {
    return Theme.of(this).extension<CosmicThemeExtension>() ?? CosmicThemeExtension.light;
  }
}