import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cat_model.dart';
import '../../data/services/cat_service.dart';
import '../../domain/cubits/liked_cats_cubit.dart';
import 'cat_detail_screen.dart';

class CatScreenController {
  final BuildContext context;
  final TickerProvider vsync;

  late AnimationController _controller;
  late Animation<Offset> animation;

  String imageUrl = '';
  String breedName = '';
  String breedDescription = 'Описание отсутствует';
  int likeCount = 0;
  int dislikeCount = 0;
  bool isLoading = false;
  bool isOnline = true;

  CatScreenController(this.context, this.vsync);

  void init() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    final state = context.read<LikedCatsCubit>().state;
    dislikeCount = state.dislikeCount;

    fetchCat();
  }

  void dispose() => _controller.dispose();

  Future<void> fetchCat() async {
    isLoading = true;
    (context as Element).markNeedsBuild();

    try {
      final catData = await CatService.fetchRandomCat();
      if (catData != null) {
        imageUrl = catData['imageUrl'] ?? '';
        breedName = catData['breedName'] ?? '';
        breedDescription = catData['breedDescription'] ?? '';
      }
    } catch (_) {
    } finally {
      isLoading = false;
      (context as Element).markNeedsBuild();
    }
  }

  void onSwipeLike() => _handleSwipe(true);

  void onSwipeDislike() => _handleSwipe(false);

  void onLikePressed() => _handleButton(true);

  void onDislikePressed() => _handleButton(false);

  void updateNetworkStatus(bool online) {
    isOnline = online;
  }

  void _handleSwipe(bool liked) {
    if (isLoading || !isOnline) return;
    _controller.reset();

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(liked ? 2.0 : -2.0, 0.0),
    ).animate(_controller);

    _controller.forward().then((_) {
      _registerLikeDislike(liked);
      _controller.reset();
      fetchCat();
    });
  }

  void _handleButton(bool liked) {
    if (isLoading) return;
    _registerLikeDislike(liked);
    fetchCat();
  }

  void _registerLikeDislike(bool liked) {
    if (liked) {
      context.read<LikedCatsCubit>().likeCat(
        CatModel(
          imageUrl: imageUrl,
          breedName: breedName,
          breedDescription: breedDescription,
          likedAt: DateTime.now(),
        ),
      );
      likeCount++;
    } else {
      context.read<LikedCatsCubit>().removeCat(
        CatModel(
          imageUrl: '', // dummy
          breedName: '',
          breedDescription: '',
          likedAt: DateTime.now(),
        ),
      );
      dislikeCount = context.read<LikedCatsCubit>().getDislikeCount();
    }
  }

  void openDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CatDetailScreen(
              imageUrl: imageUrl,
              breedName: breedName,
              breedDescription: breedDescription,
            ),
      ),
    );
  }
}
