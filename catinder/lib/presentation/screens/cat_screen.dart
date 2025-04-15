import 'package:flutter/material.dart';

import '../widgets/cat_card.dart';
import '../widgets/like_dislike_buttons.dart';
import 'cat_app_bar.dart';
import 'cat_screen_controller.dart';
import 'cat_stats_bar.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen>
    with SingleTickerProviderStateMixin {
  late final CatScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = CatScreenController(context, this);
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CatAppBar(),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cats.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    controller.isLoading
                        ? const SizedBox(
                          key: ValueKey('loader'),
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Color(0xFF388E3C),
                            ),
                          ),
                        )
                        : CatCard(
                          key: const ValueKey('catCard'),
                          imageUrl: controller.imageUrl,
                          breedName: controller.breedName,
                          breedDescription: controller.breedDescription,
                          animation: controller.animation,
                          onSwipeLike: controller.onSwipeLike,
                          onSwipeDislike: controller.onSwipeDislike,
                          onTap: controller.openDetailScreen,
                        ),
              ),
              const SizedBox(height: 10),
              CatStatsBar(dislikeCount: controller.dislikeCount),
              const SizedBox(height: 20),
              LikeDislikeButtons(
                onLike: controller.onLikePressed,
                onDislike: controller.onDislikePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
