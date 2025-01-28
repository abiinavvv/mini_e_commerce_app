import 'package:flutter/material.dart';

class AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double width;

  const AnimatedAddToCartButton({
    super.key,
    required this.onPressed,
    this.width = double.infinity,
  });

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
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

  void _onTap() async {
    widget.onPressed();
    
    // Start the animation
    await _controller.forward();
    setState(() => _isSuccess = true);
    await Future.delayed(const Duration(seconds: 1));
    
    // Reset the button
    setState(() => _isSuccess = false);
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: widget.width,
        height: 50,
        child: GestureDetector(
          onTap: _isSuccess ? null : _onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isSuccess ? widget.width : widget.width,
            decoration: BoxDecoration(
              color: _isSuccess ? Colors.green : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(_isSuccess ? 25 : 8),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSuccess
                    ? const Icon(Icons.check, color: Colors.white)
                    : ScaleTransition(
                        scale: _scaleAnimation,
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}