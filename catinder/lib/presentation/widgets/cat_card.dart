import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatCard extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final Animation<Offset> animation;
  final VoidCallback onSwipeLike;
  final VoidCallback onSwipeDislike;
  final VoidCallback onTap;

  const CatCard({
    super.key,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.animation,
    required this.onSwipeLike,
    required this.onSwipeDislike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox(height: 350, width: 320);
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          onSwipeLike();
        } else {
          onSwipeDislike();
        }
      },
      child: SlideTransition(
        position: animation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: .2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                    height: 350,
                    width: 320,
                  ),
                ),
                Container(
                  height: 50,
                  width: 320,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    breedName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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
