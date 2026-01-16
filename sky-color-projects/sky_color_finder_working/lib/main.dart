import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'utils/color_generator.dart';

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

class _SkyColorFinderScreenState extends State<SkyColorFinderScreen>
    with TickerProviderStateMixin {
  final TextEditingController _zipCodeController = TextEditingController();
  String _skyColor = '#87CEEB';
  String _timeOfDay = 'morning';
  bool _isLoading = false;
  bool _showInput = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _requestPermissions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission needed to save wallpapers'),
          ),
        );
      }
    }
  }

  Future<void> _getSkyColor(String zipCode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = SkyColorGenerator.generateSkyColor(zipCode);
      setState(() {
        _skyColor = result.color;
        _timeOfDay = result.timeOfDay;
        _showInput = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get sky color. Please try again.'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setAsWallpaper() async {
    try {
      // Create a simple image with the sky color
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(1080, 1920); // Standard phone resolution
      
      // Create gradient background
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(int.parse(_skyColor.replaceAll('#', '0xFF'))),
          Color(int.parse(SkyColorGenerator.getGradientColors(_skyColor)[1].replaceAll('#', '0xFF'))),
        ],
      );
      
      final paint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      
      // Add text
      final textPainter = TextPainter(
        text: TextSpan(
          text: SkyColorGenerator.getTimeDescription(_timeOfDay),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.4,
      ));
      
      final colorTextPainter = TextPainter(
        text: TextSpan(
          text: _skyColor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      colorTextPainter.layout();
      colorTextPainter.paint(canvas, Offset(
        (size.width - colorTextPainter.width) / 2,
        size.height * 0.5,
      ));
      
      final zipTextPainter = TextPainter(
        text: TextSpan(
          text: 'Zip: ${_zipCodeController.text}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      zipTextPainter.layout();
      zipTextPainter.paint(canvas, Offset(
        (size.width - zipTextPainter.width) / 2,
        size.height * 0.6,
      ));
      
      final picture = recorder.endRecording();
      final image = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      
      // Save to gallery
      final result = await ImageGallerySaver.saveImage(bytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sky color saved to your photos! You can now set it as wallpaper from your device settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save wallpaper. Please try again.'),
          ),
        );
      }
    }
  }

  void _resetApp() {
    setState(() {
      _zipCodeController.clear();
      _skyColor = '#87CEEB';
      _timeOfDay = 'morning';
      _showInput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _showInput ? _buildInputScreen() : _buildResultScreen(),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cloud Icon
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: const Icon(
                      Icons.cloud,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  
                  // Title
                  const Text(
                    'Sky Color Finder',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
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
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Input Container
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      children: [
                        // Zip Code Input
                        Container(
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
                              onTap: _isLoading ? null : () {
                                if (_zipCodeController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a zip code'),
                                    ),
                                  );
                                  return;
                                }
                                _getSkyColor(_zipCodeController.text);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  _isLoading ? 'Loading...' : 'Find Sky Color',
                                  style: const TextStyle(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final gradientColors = SkyColorGenerator.getGradientColors(_skyColor);
    
    return Container(
      key: const ValueKey('result'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(int.parse(_skyColor.replaceAll('#', '0xFF'))),
            Color(int.parse(gradientColors[1].replaceAll('#', '0xFF'))),
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
                        SkyColorGenerator.getTimeDescription(_timeOfDay),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _skyColor,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Zip: ${_zipCodeController.text}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Buttons Container
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    children: [
                      // Set as Wallpaper Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
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
                            onTap: _setAsWallpaper,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image, color: Colors.white, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    'Set as Wallpaper',
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
                      
                      const SizedBox(height: 15),
                      
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
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
