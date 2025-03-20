import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final List<Color> gradientColors;
  final double height;
  final double width;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const AnimatedGradientButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.gradientColors,
    this.icon,
    this.height = 56.0,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.borderRadius,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) {
          HapticFeedback.lightImpact();
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (!widget.isLoading) {
          _controller.reverse();
        }
      },
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.last.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        SizedBox(width: 12),
                      ],
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
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