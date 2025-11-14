// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Custom Image Crop Screen
class CustomImageCropScreen extends StatefulWidget {
  final File imageFile;
  final double aspectRatio;
  final bool lockAspectRatio;

  const CustomImageCropScreen({
    Key? key,
    required this.imageFile,
    this.aspectRatio = 1.0, // Default square
    this.lockAspectRatio = false,
  }) : super(key: key);

  @override
  State<CustomImageCropScreen> createState() => _CustomImageCropScreenState();
}

class _CustomImageCropScreenState extends State<CustomImageCropScreen> {
  final GlobalKey _cropKey = GlobalKey();
  Offset _panStart = Offset.zero;
  Offset _panUpdate = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;

  // Crop area
  Rect _cropRect = const Rect.fromLTWH(50, 100, 250, 250);

  // Predefined aspect ratios
  final List<AspectRatioOption> _aspectRatios = [
    AspectRatioOption('Original', -1),
    AspectRatioOption('Square', 1.0),
    AspectRatioOption('3:2', 3 / 2),
    AspectRatioOption('4:3', 4 / 3),
    AspectRatioOption('16:9', 16 / 9),
    AspectRatioOption('7:5', 7 / 5),
  ];

  int _selectedAspectRatio = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCropArea();
    });
  }

  void _initializeCropArea() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final cropSize = size.width * 0.8;
      final left = (size.width - cropSize) / 2;
      final top = (size.height - cropSize) / 2;

      setState(() {
        _cropRect = Rect.fromLTWH(left, top, cropSize, cropSize);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Crop Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _cropImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Image with gestures
                Positioned.fill(
                  child: RepaintBoundary(
                    key: _cropKey,
                    child: GestureDetector(
                      onScaleStart: (details) =>
                          _panStart = details.localFocalPoint,
                      onScaleUpdate: (details) {
                        setState(() {
                          _scale = (_scale * details.scale).clamp(0.5, 3.0);
                          _panUpdate = details.localFocalPoint - _panStart;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(_panUpdate.dx, _panUpdate.dy)
                            ..scale(_scale)
                            ..rotateZ(_rotation),
                          child: Image.file(
                            widget.imageFile,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Crop overlay
                CustomPaint(
                  painter: CropOverlayPainter(_cropRect),
                  size: Size.infinite,
                ),
                // Crop area handles
                ..._buildCropHandles(),
              ],
            ),
          ),
          // Bottom controls
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Aspect ratio selector
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _aspectRatios.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedAspectRatio == index;
                      return GestureDetector(
                        onTap: () => _selectAspectRatio(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _aspectRatios[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      Icons.rotate_left,
                      'Rotate',
                      () =>
                          setState(() => _rotation -= 0.785398), // -45 degrees
                    ),
                    _buildControlButton(
                      Icons.flip,
                      'Flip',
                      () => setState(() => _scale *= -1),
                    ),
                    _buildControlButton(
                      Icons.refresh,
                      'Reset',
                      _resetTransform,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCropHandles() {
    return [
      // Corner handles
      _buildHandle(
        _cropRect.topLeft,
        (delta) => _updateCropRect(
          left: _cropRect.left + delta.dx,
          top: _cropRect.top + delta.dy,
        ),
      ),
      _buildHandle(
        _cropRect.topRight,
        (delta) => _updateCropRect(
          right: _cropRect.right + delta.dx,
          top: _cropRect.top + delta.dy,
        ),
      ),
      _buildHandle(
        _cropRect.bottomLeft,
        (delta) => _updateCropRect(
          left: _cropRect.left + delta.dx,
          bottom: _cropRect.bottom + delta.dy,
        ),
      ),
      _buildHandle(
        _cropRect.bottomRight,
        (delta) => _updateCropRect(
          right: _cropRect.right + delta.dx,
          bottom: _cropRect.bottom + delta.dy,
        ),
      ),
    ];
  }

  Widget _buildHandle(Offset position, Function(Offset) onPan) {
    return Positioned(
      left: position.dx - 10,
      top: position.dy - 10,
      child: GestureDetector(
        onPanUpdate: (details) => onPan(details.delta),
        child: Container(
          width: 20,
          height: 20,
          decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateCropRect({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    setState(() {
      _cropRect = Rect.fromLTRB(
        left ?? _cropRect.left,
        top ?? _cropRect.top,
        right ?? _cropRect.right,
        bottom ?? _cropRect.bottom,
      );
    });
  }

  void _selectAspectRatio(int index) {
    setState(() {
      _selectedAspectRatio = index;
      if (index > 0) {
        final aspectRatio = _aspectRatios[index].ratio;
        final center = _cropRect.center;
        final currentWidth = _cropRect.width;
        final newHeight = currentWidth / aspectRatio;

        _cropRect = Rect.fromCenter(
          center: center,
          width: currentWidth,
          height: newHeight,
        );
      }
    });
  }

  void _resetTransform() {
    setState(() {
      _scale = 1.0;
      _rotation = 0.0;
      _panUpdate = Offset.zero;
    });
  }

  Future<void> _cropImage() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      // Capture the cropped area
      final RenderRepaintBoundary boundary =
          _cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List imageBytes = byteData.buffer.asUint8List();

        // Create temporary file
        final tempDir = Directory.systemTemp;
        final tempFile = File(
            '${tempDir.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(imageBytes);

        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context, tempFile); // Return cropped file
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cropping image: $e')),
      );
    }
  }
}

// Crop overlay painter
class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter(this.cropRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw overlay (darkened areas outside crop)
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(fullRect)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(cropRect, borderPaint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Vertical lines
    final thirdWidth = cropRect.width / 3;
    canvas.drawLine(
      Offset(cropRect.left + thirdWidth, cropRect.top),
      Offset(cropRect.left + thirdWidth, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left + thirdWidth * 2, cropRect.top),
      Offset(cropRect.left + thirdWidth * 2, cropRect.bottom),
      gridPaint,
    );

    // Horizontal lines
    final thirdHeight = cropRect.height / 3;
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdHeight),
      Offset(cropRect.right, cropRect.top + thirdHeight),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdHeight * 2),
      Offset(cropRect.right, cropRect.top + thirdHeight * 2),
      gridPaint,
    );
  }

  @override
  bool shouldRepaint(CropOverlayPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect;
  }
}

// Aspect ratio option model
class AspectRatioOption {
  final String name;
  final double ratio;

  AspectRatioOption(this.name, this.ratio);
}
