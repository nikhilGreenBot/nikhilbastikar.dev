import 'dart:math';

class SkyColorGenerator {
  static Map<String, List<String>> skyColors = {
    'night': ['#0B1426', '#1a1a2e', '#16213e', '#0f3460', '#1e3a8a'],
    'dawn': ['#FF6B6B', '#FF8E53', '#FFB347', '#FFD93D', '#FFE66D'],
    'morning': ['#87CEEB', '#87CEFA', '#B0E0E6', '#ADD8E6', '#E0F6FF'],
    'noon': ['#4A90E2', '#1E90FF', '#00BFFF', '#87CEEB', '#B0E0E6'],
    'afternoon': ['#4682B4', '#5F9EA0', '#6495ED', '#7B68EE', '#9370DB'],
    'dusk': ['#FF6B6B', '#FF8E53', '#FFB347', '#FFD93D', '#FFE66D'],
    'evening': ['#191970', '#483D8B', '#6A5ACD', '#7B68EE', '#9370DB']
  };

  static Map<String, String> timeDescriptions = {
    'night': 'Night Sky',
    'dawn': 'Dawn Breaking',
    'morning': 'Morning Sky',
    'noon': 'Midday Sky',
    'afternoon': 'Afternoon Sky',
    'dusk': 'Dusk Setting',
    'evening': 'Evening Sky'
  };

  static Map<String, List<String>> gradientColors = {
    '#87CEEB': ['#4A90E2', '#7B68EE'],
    '#4682B4': ['#2E5A88', '#5F9EA0'],
    '#1E90FF': ['#0066CC', '#4A90E2'],
    '#00BFFF': ['#0099CC', '#87CEEB'],
    '#87CEFA': ['#5F9EA0', '#B0E0E6'],
    '#B0E0E6': ['#87CEEB', '#E0F6FF'],
    '#ADD8E6': ['#87CEEB', '#F0F8FF'],
    '#F0F8FF': ['#E0F6FF', '#FFFFFF'],
    '#E0F6FF': ['#B0E0E6', '#F0F8FF'],
    '#B8E6B8': ['#90EE90', '#E0F6FF'],
    '#191970': ['#000080', '#483D8B'],
    '#FF6B6B': ['#FF4757', '#FF6B6B'],
    '#FF8E53': ['#FF6B6B', '#FF8E53'],
    '#FFB347': ['#FF8E53', '#FFB347'],
    '#FFD93D': ['#FFB347', '#FFD93D'],
    '#FFE66D': ['#FFD93D', '#FFE66D']
  };

  static SkyColorResult generateSkyColor(String zipCode, {DateTime? timestamp}) {
    final date = timestamp ?? DateTime.now();
    final hour = date.hour;
    final minute = date.minute;
    
    // Convert zip code to a seed for consistent colors
    final seed = int.tryParse(zipCode) ?? 10000;
    
    // Determine time of day
    String timeOfDay;
    if (hour >= 22 || hour < 6) {
      timeOfDay = 'night';
    } else if (hour >= 6 && hour < 8) {
      timeOfDay = 'dawn';
    } else if (hour >= 8 && hour < 12) {
      timeOfDay = 'morning';
    } else if (hour >= 12 && hour < 16) {
      timeOfDay = 'noon';
    } else if (hour >= 16 && hour < 18) {
      timeOfDay = 'afternoon';
    } else if (hour >= 18 && hour < 20) {
      timeOfDay = 'dusk';
    } else {
      timeOfDay = 'evening';
    }
    
    // Select color based on seed and time
    final colors = skyColors[timeOfDay] ?? skyColors['morning']!;
    final colorIndex = seed % colors.length;
    String baseColor = colors[colorIndex];
    
    // Add subtle variations based on minutes
    final minuteVariation = (minute / 60) * 0.1;
    final adjustedColor = _adjustColorBrightness(baseColor, minuteVariation);
    
    return SkyColorResult(
      color: adjustedColor,
      timeOfDay: timeOfDay,
      hour: hour,
      minute: minute,
    );
  }

  static String _adjustColorBrightness(String hex, double factor) {
    // Remove # if present
    hex = hex.replaceAll('#', '');
    
    // Parse RGB values
    final r = int.parse(hex.substring(0, 2), radix: 16);
    final g = int.parse(hex.substring(2, 4), radix: 16);
    final b = int.parse(hex.substring(4, 6), radix: 16);
    
    // Adjust brightness
    final newR = (r + (factor * 255)).clamp(0, 255).round();
    final newG = (g + (factor * 255)).clamp(0, 255).round();
    final newB = (b + (factor * 255)).clamp(0, 255).round();
    
    // Convert back to hex
    return '#${newR.toRadixString(16).padLeft(2, '0')}${newG.toRadixString(16).padLeft(2, '0')}${newB.toRadixString(16).padLeft(2, '0')}';
  }

  static List<String> getGradientColors(String baseColor) {
    return gradientColors[baseColor] ?? ['#4A90E2', '#7B68EE'];
  }

  static String getTimeDescription(String timeOfDay) {
    return timeDescriptions[timeOfDay] ?? 'Sky Color';
  }
}

class SkyColorResult {
  final String color;
  final String timeOfDay;
  final int hour;
  final int minute;

  SkyColorResult({
    required this.color,
    required this.timeOfDay,
    required this.hour,
    required this.minute,
  });
}
