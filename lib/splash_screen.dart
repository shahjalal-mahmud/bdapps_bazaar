import 'package:flutter/material.dart';
import 'home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SplashScreen
//
//  Shown immediately on launch (covers the black frame Flutter shows before
//  the first frame is rendered in debug mode).
//
//  Sequence:
//    0 ms  → screen visible (purple gradient, no content)
//   200 ms → logo icon fades + scales in
//   500 ms → app name slides up and fades in
//   900 ms → tagline fades in
//  1800 ms → fade-out begins, navigate to HomeScreen
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ─────────────────────────────────────────────────
  late final AnimationController _logoCtrl;
  late final AnimationController _titleCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _exitCtrl;

  // ── Animations ────────────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    // Logo: scale from 0.5 → 1.0 with elastic feel
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Title: slide up from +20px, fade in
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOutCubic));
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
    );

    // Tagline: simple fade
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );

    // Exit: fade entire screen to white before navigate
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _exitFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Small initial pause so the gradient renders before animating
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _titleCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    _taglineCtrl.forward();

    // Hold the splash for a moment
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Fade out and navigate
    await _exitCtrl.forward();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),
      body: AnimatedBuilder(
        animation: _exitFade,
        builder: (context, child) {
          return Stack(
            children: [
              // ── Background gradient ─────────────────────────────────────
              child!,

              // ── White fade-out overlay ──────────────────────────────────
              if (_exitFade.value > 0)
                Opacity(
                  opacity: _exitFade.value,
                  child: const ColoredBox(
                    color: Color(0xFFF4F6FB),
                    child: SizedBox.expand(),
                  ),
                ),
            ],
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5), Color(0xFF3730A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ── Decorative background shapes ──────────────────────────
              Positioned(
                top: -size.height * 0.08,
                right: -size.width * 0.15,
                child: _Circle(
                  size: size.width * 0.65,
                  opacity: 0.08,
                ),
              ),
              Positioned(
                bottom: size.height * 0.12,
                left: -size.width * 0.18,
                child: _Circle(
                  size: size.width * 0.55,
                  opacity: 0.06,
                ),
              ),
              Positioned(
                top: size.height * 0.6,
                right: size.width * 0.05,
                child: _Circle(
                  size: size.width * 0.28,
                  opacity: 0.06,
                ),
              ),

              // ── Grid dots pattern (top-right area) ───────────────────
              Positioned(
                top: size.height * 0.06,
                right: size.width * 0.06,
                child: const _DotGrid(columns: 5, rows: 4, opacity: 0.15),
              ),
              Positioned(
                bottom: size.height * 0.08,
                left: size.width * 0.06,
                child: const _DotGrid(columns: 4, rows: 3, opacity: 0.12),
              ),

              // ── Main content ──────────────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo icon with glowing ring
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoFade,
                        child: _LogoBadge(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App name
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: const _AppTitle(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    FadeTransition(
                      opacity: _taglineFade,
                      child: const _Tagline(),
                    ),
                  ],
                ),
              ),

              // ── Bottom loading indicator ──────────────────────────────
              Positioned(
                bottom: size.height * 0.1,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: const _LoadingDots(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  final int columns;
  final int rows;
  final double opacity;
  const _DotGrid(
      {required this.columns, required this.rows, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(columns, (c) {
            return Container(
              margin: const EdgeInsets.all(5),
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
        ),
        // Inner badge
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
        ),
        // Icon
        Container(
          width: 68,
          height: 68,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(
            Icons.storefront_rounded,
            size: 36,
            color: Color(0xFF6C3EF4),
          ),
        ),
      ],
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'BdApps ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
          TextSpan(
            text: 'Bazaar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: const Text(
        'Your Premium Marketplace',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400 + i * 100),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == 1 ? 20 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: i == 1 ? 0.9 : 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}