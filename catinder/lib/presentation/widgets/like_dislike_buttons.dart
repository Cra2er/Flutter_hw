import 'package:flutter/material.dart';

class LikeDislikeButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final bool isOnline;

  const LikeDislikeButtons({
    super.key,
    required this.onLike,
    required this.onDislike,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: IconButton(
            icon: const Icon(Icons.heart_broken, color: Colors.white),
            iconSize: 50,
            onPressed: isOnline ? onDislike : null,
          ),
        ),
        const SizedBox(width: 50),
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            iconSize: 50,
            onPressed: isOnline ? onLike : null,
          ),
        ),
      ],
    );
  }
}
