import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SkyColorFinderApp());
}

class SkyColorFinderApp extends StatelessWidget {
  const SkyColorFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Color Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SkyColorFinderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SkyColorFinderScreen extends StatefulWidget {
  const SkyColorFinderScreen({super.key});

  @override
  State<SkyColorFinderScreen> createState() => _SkyColorFinderScreenState();
}

class _SkyColorFinderScreenState extends State<SkyColorFinderScreen> {
  final TextEditingController _zipCodeController = TextEditingController();
  String _skyColor = '#87CEEB';
  bool _showResult = false;

  // Simple sky colors based on time of day
  final Map<String, List<String>> _skyColors = {
    'morning': ['#87CEEB', '#B0E0E6', '#ADD8E6', '#E0F6FF'],
    'noon': ['#4A90E2', '#1E90FF', '#00BFFF', '#87CEEB'],
    'afternoon': ['#4682B4', '#5F9EA0', '#6495ED', '#7B68EE'],
    'evening': ['#FF6B6B', '#FF8E53', '#FFB347', '#FFD93D'],
    'night': ['#191970', '#483D8B', '#6A5ACD', '#7B68EE'],
  };

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 16) return 'noon';
    if (hour >= 16 && hour < 18) return 'afternoon';
    if (hour >= 18 && hour < 20) return 'evening';
    return 'night';
  }

  void _findSkyColor() {
    if (_zipCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a zip code')),
      );
      return;
    }

    final timeOfDay = _getTimeOfDay();
    final colors = _skyColors[timeOfDay] ?? _skyColors['morning']!;
    
    // Use zip code as seed for consistent colors
    final seed = int.tryParse(_zipCodeController.text) ?? 10000;
    final colorIndex = seed % colors.length;
    
    setState(() {
      _skyColor = colors[colorIndex];
      _showResult = true;
    });
  }

  void _resetApp() {
    setState(() {
      _zipCodeController.clear();
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _showResult ? _buildResultScreen() : _buildInputScreen(),
      ),
    );
  }

  Widget _buildInputScreen() {
    return Container(
      key: const ValueKey('input'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF7B68EE)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cloud Icon
                const Icon(
                  Icons.cloud,
                  size: 80,
                  color: Colors.white,
                ),
                
                const SizedBox(height: 30),
                
                // Title
                const Text(
                  'Sky Color Finder',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 10),
                
                // Subtitle
                const Text(
                  'Enter your zip code to see the sky color',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Zip Code Input
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Enter Zip Code',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      counterText: '',
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Find Sky Color Button
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 300),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: _findSkyColor,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Find Sky Color',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Container(
      key: const ValueKey('result'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(int.parse(_skyColor.replaceAll('#', '0xFF'))),
            Color(int.parse(_skyColor.replaceAll('#', '0xFF'))).withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Color Display
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getTimeOfDay().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _skyColor,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Zip: ${_zipCodeController.text}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Buttons
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    children: [
                      // Try Another Zip Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: _resetApp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh, color: Colors.white, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    'Try Another Zip',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
