import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/app_text.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  double _angle = 0.10;

  static const List<_MoodData> _moods = [
    _MoodData('Calm', 'assets/images/clam.png'),
    _MoodData('Content', 'assets/images/content.png'),
    _MoodData('Peaceful', 'assets/images/peaceful.png'),
    _MoodData('Happy', 'assets/images/happy.png'),
  ];

  _MoodData get _selectedMood {
    final int index = _moodIndexFromAngle(_angle);
    return _moods[index];
  }

  @override
  Widget build(BuildContext context) {
    final _MoodData mood = _selectedMood;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.1, -1.0),
            radius: 1.15,
            colors: [Color(0xFF2C4A7D), Color(0xFF07151C), Colors.black],
            stops: [0.0, 0.4, 0.85],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h),
                const AppText('Mood', size: 21, weight: FontWeight.w500),
                SizedBox(height: 22.h),
                const AppText(
                  'Start your day',
                  size: 14,
                  color: Colors.white70,
                ),
                SizedBox(height: 10.h),
                const AppText(
                  'How are you feeling at the\nMoment?',
                  size: 19,
                  weight: FontWeight.w600,
                  height: 1.25,
                ),
                SizedBox(height: 34.h),
                Center(
                  child: _MoodWheel(
                    angle: _angle,
                    mood: mood,
                    onChanged: (value) => setState(() => _angle = value),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: AppText(mood.label, size: 23, weight: FontWeight.w500),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const AppText(
                      'Continue',
                      size: 14,
                      color: Colors.black,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodWheel extends StatelessWidget {
  const _MoodWheel({
    required this.angle,
    required this.mood,
    required this.onChanged,
  });

  final double angle;
  final _MoodData mood;
  final ValueChanged<double> onChanged;

  static const double _size = 290;
  static const double _ringThickness = 32;

  @override
  Widget build(BuildContext context) {
    final double size = _size.w;
    final double radius = size / 2;
    final double ringRadius = radius - (_ringThickness.w / 2);
    final double handleAngle = angle * 2 * math.pi - math.pi / 2;
    final Offset handleCenter = Offset(
      radius + ringRadius * math.cos(handleAngle),
      radius + ringRadius * math.sin(handleAngle),
    );

    return GestureDetector(
      onPanStart: (d) => _updateFromLocal(d.localPosition, size),
      onPanUpdate: (d) => _updateFromLocal(d.localPosition, size),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(thickness: _ringThickness.w),
            ),
            Positioned.fill(
              child: Center(child: _MoodFace(mood: mood)),
            ),
            Positioned(
              left: handleCenter.dx - 22.w,
              top: handleCenter.dy - 22.w,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
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

  void _updateFromLocal(Offset local, double size) {
    final Offset center = Offset(size / 2, size / 2);
    final Offset v = local - center;
    final double theta = math.atan2(v.dy, v.dx);
    final double normalized = _normalized(
      (theta + math.pi / 2) / (2 * math.pi),
    );
    onChanged(normalized);
  }
}

class _MoodFace extends StatelessWidget {
  const _MoodFace({required this.mood});

  final _MoodData mood;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        width: 112.w,
        height: 112.w,
        color: const Color(0xFF1A1E26),
        alignment: Alignment.center,
        child: Image.asset(
          mood.imagePath,
          width: 112.w,
          height: 112.w,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.thickness});

  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Offset center = rect.center;
    final double radius = size.width / 2 - thickness / 2;

    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = const SweepGradient(
       colors: [
          Color(0xFF7AC9C1),
          Color(0xFF7AC9C1),
          Color(0xFFC2B2EC),
          Color(0xFFC2B2EC),
          Color(0xFFEC8EB7), 
          Color(0xFFEC8EB7),
          Color(0xFFFFA65D), 
          Color(0xFFFFA65D),
          Color(0xFF7AC9C1), 
        ],
        stops: [
          0.00,
          0.20,
          0.30,
          0.45,
          0.55,
          0.70,
          0.80,
          0.95,
          1.00,
        ],
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
      ).createShader(rect);

    canvas.drawCircle(center, radius, ring);

    final Paint div = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const int segments = 12;
    for (int i = 0; i < segments; i++) {
      if (i % 3 == 0) continue;
      final double a = (-math.pi / 2) + (2 * math.pi / segments) * i;
      final Offset p1 = Offset(
        center.dx + (radius - thickness / 2) * math.cos(a),
        center.dy + (radius - thickness / 2) * math.sin(a),
      );
      final Offset p2 = Offset(
        center.dx + (radius + thickness / 2) * math.cos(a),
        center.dy + (radius + thickness / 2) * math.sin(a),
      );
      canvas.drawLine(p1, p2, div);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}

class _MoodData {
  const _MoodData(this.label, this.imagePath);

  final String label;
  final String imagePath;
}

int _moodIndexFromAngle(double angle) {
  final double n = _normalized(angle);
  if (n < 0.25) return 0;
  if (n < 0.5) return 1;
  if (n < 0.75) return 2;
  return 3;
}

double _normalized(double value) {
  final double v = value % 1;
  return v < 0 ? v + 1 : v;
}
