import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final Widget titleWidget;
  final Widget contentWidget;
  final bool isExpanded;
  final double availableHeight;
  final double collapsedHeight;
  final VoidCallback onTap;

  const CustomDropdown({
    super.key,
    required this.titleWidget,
    required this.contentWidget,
    required this.isExpanded,
    required this.availableHeight,
    required this.collapsedHeight,
    required this.onTap,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: widget.collapsedHeight,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: widget.titleWidget,
          ),
        ),
        ClipRect(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: widget.isExpanded ? widget.availableHeight : 0,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: OverflowBox(
                    minHeight: widget.availableHeight,
                    maxHeight: widget.availableHeight,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: widget.contentWidget,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
