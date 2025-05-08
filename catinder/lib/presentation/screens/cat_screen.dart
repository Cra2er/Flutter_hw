import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/services/network_service.dart';
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
  late final NetworkService _networkService;
  StreamSubscription<bool>? _networkSubscription;
  bool _wasOffline = false;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    controller = CatScreenController(context, this);
    controller.init();

    _networkService = NetworkService();
    _networkSubscription = _networkService.onNetworkStatusChange.listen((
      isOnline,
    ) {
      if (!mounted) return;

      setState(() {
        _isOnline = isOnline;
        controller.updateNetworkStatus(isOnline);
      });

      if (!isOnline && !_wasOffline) {
        _wasOffline = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Нет подключения к сети'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (isOnline && _wasOffline) {
        _wasOffline = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Подключение восстановлено'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    _networkService.dispose();
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
              SizedBox(
                height: 400,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1),
                  child:
                      controller.isLoading
                          ? const SizedBox(
                            key: ValueKey('loader'),
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
              ),
              const SizedBox(height: 10),
              const CatStatsBar(),
              const SizedBox(height: 20),
              LikeDislikeButtons(
                onLike: controller.onLikePressed,
                onDislike: controller.onDislikePressed,
                isOnline: _isOnline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
