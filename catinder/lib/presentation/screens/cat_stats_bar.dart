import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/liked_cats_cubit.dart';

class CatStatsBar extends StatelessWidget {
  const CatStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedCatsCubit, LikedCatsState>(
      builder: (context, state) {
        final likeCount = state.likedCats.length;
        final dislikeCount = context.read<LikedCatsCubit>().getDislikeCount();
        final total =
            (likeCount + dislikeCount).clamp(1, double.infinity).toDouble();
        final likeRatio = dislikeCount / total;

        return Column(
          children: [
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green, width: 3),
              ),
              child: LinearProgressIndicator(
                value: likeRatio,
                backgroundColor: Colors.green,
                color: Colors.red,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 24),
                children: [
                  TextSpan(
                    text: 'Dislikes: $dislikeCount |',
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: '| Likes: $likeCount',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
