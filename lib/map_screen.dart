import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController pulseController;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool showZombieAlert = false;
  bool pulseFlash = false;

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      setState(() {
        showZombieAlert = true;
      });
    });
  }

  Future<void> playPulseAttack() async {
    await _audioPlayer.play(AssetSource('sounds/pulse_attack.mp3'));
  }

  Future<void> activatePulse() async {
    setState(() {
      pulseFlash = true;
    });

    await playPulseAttack();

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    setState(() {
      pulseFlash = false;
    });
  }

  @override
  void dispose() {
    pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showEnemyEncounter() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "INFECTED DETECTED",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 80),
              SizedBox(height: 20),
              Text(
                "Runner-Class Zombie\n\nWeakness: Sonic Pulse",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () async {
                Navigator.pop(context);

                await activatePulse();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("SONIC PULSE EMITTED\nTARGET NEUTRALIZED"),
                  ),
                );
              },
              child: const Text("EMIT SONIC PULSE"),
            ),
          ],
        );
      },
    );
  }

  Widget buildMarker({
    required IconData icon,
    required Color color,
    required double left,
    required double top,
    VoidCallback? onTap,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: color, size: 42),
      ),
    );
  }

  Widget buildLegendCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EVACNET GUIDE",
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.blue),
              SizedBox(width: 8),
              Text("You", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.home, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text("Safe House", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.warning, color: Colors.redAccent),
              SizedBox(width: 8),
              Text("Infected Zone", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.rocket_launch, color: Colors.orange),
              SizedBox(width: 8),
              Text("Extraction Rocket", style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.redAccent,
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(Icons.satellite_alt, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    "EXTRACTION ROUTE FOUND",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  const PrototypeMapBackground(),

                  if (pulseFlash)
                    Container(color: Colors.cyan.withOpacity(.45)),

                  CustomPaint(size: Size.infinite, painter: RoutePainter()),

                  buildMarker(
                    icon: Icons.person_pin_circle,
                    color: Colors.blue,
                    left: 60,
                    top: 540,
                  ),

                  buildMarker(
                    icon: Icons.home,
                    color: Colors.greenAccent,
                    left: 120,
                    top: 410,
                  ),

                  buildMarker(
                    icon: Icons.warning,
                    color: Colors.redAccent,
                    left: 220,
                    top: 280,
                    onTap: _showEnemyEncounter,
                  ),

                  buildMarker(
                    icon: Icons.warning,
                    color: Colors.redAccent,
                    left: 290,
                    top: 180,
                    onTap: _showEnemyEncounter,
                  ),

                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.greenAccent),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "GPS SIGNAL ACQUIRED",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "SECTOR ATL-07",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: pulseController,
                    builder: (_, __) {
                      return Positioned(
                        right: 40,
                        top: 80,
                        child: Transform.scale(
                          scale: 1 + pulseController.value * .15,
                          child: const Icon(
                            Icons.rocket_launch,
                            color: Colors.orange,
                            size: 70,
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: buildLegendCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showZombieAlert
          ? FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: _showEnemyEncounter,
              icon: const Icon(Icons.warning),
              label: const Text("INFECTED"),
            )
          : null,
    );
  }
}

class PrototypeMapBackground extends StatelessWidget {
  const PrototypeMapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: PrototypeMapPainter(), size: Size.infinite);
  }
}

class PrototypeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF141414),
    );

    final gridPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(50, 580), const Offset(330, 120), roadPaint);

    canvas.drawLine(const Offset(40, 330), const Offset(360, 330), roadPaint);

    canvas.drawLine(const Offset(150, 80), const Offset(150, 650), roadPaint);

    final buildingPaint = Paint()..color = const Color(0xFF242424);

    final buildingBorder = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke;

    final buildings = [
      const Rect.fromLTWH(25, 70, 80, 75),
      const Rect.fromLTWH(200, 90, 90, 70),
      const Rect.fromLTWH(230, 230, 90, 90),
      const Rect.fromLTWH(25, 430, 110, 80),
      const Rect.fromLTWH(180, 420, 120, 100),
    ];

    for (final building in buildings) {
      final rrect = RRect.fromRectAndRadius(building, const Radius.circular(8));

      canvas.drawRRect(rrect, buildingPaint);
      canvas.drawRRect(rrect, buildingBorder);
    }

    canvas.drawCircle(
      const Offset(130, 420),
      65,
      Paint()..color = Colors.green.withOpacity(.25),
    );

    canvas.drawCircle(
      const Offset(240, 290),
      70,
      Paint()..color = Colors.red.withOpacity(.25),
    );

    canvas.drawCircle(
      const Offset(290, 190),
      60,
      Paint()..color = Colors.red.withOpacity(.25),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(80, 560);
    path.quadraticBezierTo(120, 500, 145, 420);
    path.quadraticBezierTo(200, 330, 240, 290);
    path.quadraticBezierTo(300, 180, 340, 100);

    final glow = Paint()
      ..color = Colors.greenAccent.withOpacity(.30)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final route = Paint()
      ..color = const Color(0xFF00FF95)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, glow);
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
