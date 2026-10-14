import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/map_screen.dart';

void main() {
  runApp(const EvacNetApp());
}

class EvacNetApp extends StatelessWidget {
  const EvacNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EvacNet',
      theme: ThemeData.dark(),
      home: const IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final String introMessage = '''
GLOBAL ALERT

Earth evacuation protocol activated.

Major cities have fallen.

Communications are unstable.

EvacNet has been deployed automatically to all remaining devices.

This system exists for one purpose:

GET YOU OFF EARTH.
''';

  final String evacuationText = "BEGIN EVACUATION";

  String displayedText = "";

  int introIndex = 0;
  int evacuationIndex = 0;

  double glitchOffset = 0;

  Timer? introTimer;
  Timer? glitchTimer;

  late AnimationController pulseController;

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    startIntroTyping();
    startGlitchEffect();
  }

  void startIntroTyping() {
    introTimer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (introIndex < introMessage.length) {
        setState(() {
          displayedText += introMessage[introIndex];
          introIndex++;
        });
      } else {
        timer.cancel();
        startEvacuationTyping();
      }
    });
  }

  void startEvacuationTyping() {
    Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (evacuationIndex < evacuationText.length) {
        setState(() {
          evacuationIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void startGlitchEffect() {
    glitchTimer = Timer.periodic(const Duration(milliseconds: 2400), (timer) {
      setState(() {
        glitchOffset = Random().nextDouble() * 10 - 5;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;

        setState(() {
          glitchOffset = 0;
        });
      });
    });
  }

  @override
  void dispose() {
    introTimer?.cancel();
    glitchTimer?.cancel();
    pulseController.dispose();
    super.dispose();
  }

  Widget buildEvacuationText() {
    final styles = [
      const TextStyle(
        color: Colors.redAccent,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ),
      const TextStyle(
        color: Colors.orange,
        fontSize: 34,
        fontWeight: FontWeight.w900,
      ),
      const TextStyle(
        color: Colors.white,
        fontSize: 50,
        fontWeight: FontWeight.w900,
      ),
      const TextStyle(
        color: Colors.red,
        fontSize: 38,
        fontWeight: FontWeight.bold,
      ),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(evacuationIndex, (index) {
        final char = evacuationText[index];

        if (char == " ") {
          return const SizedBox(width: 12);
        }

        return Padding(
          padding: EdgeInsets.only(
            top: index % 3 == 0 ? 0 : 5,
            left: 2,
            right: 2,
          ),
          child: Text(char, style: styles[index % styles.length]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 1.2,
                colors: [Color(0xFF330000), Color(0xFF050505)],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: 450 + (pulseController.value * 70),
                  height: 450 + (pulseController.value * 70),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.05),
                  ),
                ),
              );
            },
          ),

          Transform.translate(
            offset: Offset(glitchOffset, 0),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      children: [
                        Text(
                          "EVACNET",
                          style: TextStyle(
                            fontSize: 52,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "LAST SURVIVOR NETWORK",
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      displayedText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),

                    AnimatedOpacity(
                      opacity: evacuationIndex > 0 ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: buildEvacuationText(),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MapScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "I'M STILL ALIVE",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const CRTScanlines(),
        ],
      ),
    );
  }
}

class CRTScanlines extends StatelessWidget {
  const CRTScanlines({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: ScanlinePainter()),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.03);

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
