import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const CartBadge({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.blueAccent,
              size: 28,
            ),

            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedScale(
                  scale: count > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.elasticOut,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}