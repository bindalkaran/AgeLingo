import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/app_theme.dart';

class AnimatedTermCard extends StatefulWidget {
  final Term term;
  final VoidCallback onTap;

  const AnimatedTermCard({
    Key? key,
    required this.term,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedTermCardState createState() => _AnimatedTermCardState();
}

class _AnimatedTermCardState extends State<AnimatedTermCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getGenerationColor(String generation) {
    switch (generation) {
      case 'Boomers':
        return AppTheme.boomersColor;
      case 'Gen X':
        return AppTheme.genXColor;
      case 'Millennials':
        return AppTheme.millennialsColor;
      case 'Gen Z':
        return AppTheme.genZColor;
      case 'Gen Alpha':
        return AppTheme.genAlphaColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final generationColor = _getGenerationColor(widget.term.generation);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          _controller.reverse();
        },
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
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: generationColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Generation color indicator
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      color: generationColor,
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.term.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildGenerationBadge(widget.term.generation),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.term.definition,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Example icon
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: generationColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    size: 14,
                                    color: generationColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Example',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: generationColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Translation Count icon
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode 
                                    ? Colors.white10 
                                    : Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.translate,
                                    size: 14,
                                    color: isDarkMode 
                                        ? Colors.white70 
                                        : Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.term.translations.length - 1} translations',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode 
                                          ? Colors.white70 
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: isDarkMode ? Colors.white38 : Colors.black38,
                            ),
                          ],
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

  Widget _buildGenerationBadge(String generation) {
    final color = _getGenerationColor(generation);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        generation,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
} 