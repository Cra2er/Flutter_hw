import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          child: imageUrl.isEmpty
              ? const CircularProgressIndicator(color: Colors.white)
              : Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: .5),
                  blurRadius: 10,
                  spreadRadius: 10,
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
                    placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                    height: 350,
                    width: 320,
                  ),
                ),
                Container(
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
