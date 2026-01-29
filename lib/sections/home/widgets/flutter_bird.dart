import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/images.dart';

class FlutterBird extends StatefulWidget {
  final double? availableWidth;
  final double scale;

  const FlutterBird({super.key, this.availableWidth, this.scale = 4});

  @override
  State<FlutterBird> createState() => _FlutterBirdState();
}

class _FlutterBirdState extends State<FlutterBird>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _spinController;
  Animation<double>? _returnDx;
  late final Animation<double> _rotation;
  double _dx = 0;

  double _maxDx = 400;
  VoidCallback? _controllerListener;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    final listener = _controllerListener;
    if (listener != null) {
      _controller.removeListener(listener);
    }
    _controller.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dx == 0) return;

    _returnDx = Tween<double>(begin: _dx, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    final prevListener = _controllerListener;
    if (prevListener != null) {
      _controller.removeListener(prevListener);
    }

    _controllerListener = () {
      final value = _returnDx?.value;
      if (!mounted || value == null) return;
      setState(() => _dx = value);
    };

    _controller
      ..reset()
      ..addListener(_controllerListener!)
      ..forward().whenComplete(() {
        if (!mounted) return;
        setState(() => _dx = 0);
      });
  }

  Future<void> _handleTap() async {
    if (_spinController.isAnimating) return;
    await _spinController.forward(from: 0);
    if (mounted) {
      await _spinController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.availableWidth != null) {
      double percentage;
      if (screenWidth > 1300) {
        percentage = 0.40;
      } else if (screenWidth > 1150) {
        percentage = 0.30;
      } else if (screenWidth >= 1020) {
        percentage = 0.20;
      } else if (screenWidth >= 910) {
        percentage = 0.0;
      } else {
        percentage = 0.10;
      }
      _maxDx = widget.availableWidth! * percentage;
    } else {
      _maxDx = screenWidth * 0.25;
    }

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: _handleTap,
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: AnimatedBuilder(
          animation: _rotation,
          builder: (context, child) {
            final angle = _rotation.value;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle);
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: child,
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Transform.scale(
              scale: widget.scale,
              child: Image.asset(AppImages.flutterBird, width: 48, height: 48),
            ),
          ),
        ),
      ),
    );
  }
}
