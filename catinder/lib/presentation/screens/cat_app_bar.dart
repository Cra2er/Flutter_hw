import 'package:flutter/material.dart';

import 'liked_cats_screen.dart';

class CatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD5F5E3), Color(0xFFABEBC6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(bottom: BorderSide(color: Colors.green, width: 1.2)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catinder 🐾',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black.withValues(alpha: .4),
                      pageBuilder: (_, __, ___) => const LikedCatsScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Favorite',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Icon(Icons.favorite, color: Colors.green, size: 26),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
