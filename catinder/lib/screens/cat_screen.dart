import 'package:flutter/material.dart';
import 'cat_detail_screen.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_dislike_buttons.dart';
import '../widgets/cat_service.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  CatScreenState createState() => CatScreenState();
}

class CatScreenState extends State<CatScreen> with SingleTickerProviderStateMixin {
  String imageUrl = '';
  String breedName = '';
  String breedDescription = 'Описание отсутствует';
  int likeCount = 0;
  int dislikeCount = 0;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    fetchCat();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);
  }

  Future<void> fetchCat() async {
    final catData = await CatService.fetchRandomCat();
    if (catData != null) {
      setState(() {
        imageUrl = catData['imageUrl'] ?? '';
        breedName = catData['breedName'] ?? '';
        breedDescription = catData['breedDescription'] ?? '';

      });
    }
  }

  void _handleSwipe(bool liked) {
    _controller.reset();

    setState(() {
      _animation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(liked ? 2.0 : -2.0, 0.0),
      ).animate(_controller);
    });

    _controller.forward().then((_) {
      setState(() {
        liked ? likeCount++ : dislikeCount++;

        _controller.reset();

        fetchCat();
      });
    });
  }



  void _handleButtonPress(bool liked) {
    setState(() {
      liked ? likeCount++ : dislikeCount++;
    });
    fetchCat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = (likeCount + dislikeCount == 0) ? 1 : (likeCount + dislikeCount).toDouble();
    double likeRatio = dislikeCount / total;

    return Scaffold(
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
              CatCard(
                imageUrl: imageUrl,
                breedName: breedName,
                breedDescription: breedDescription,
                animation: _animation,
                onSwipeLike: () => _handleSwipe(true),
                onSwipeDislike: () => _handleSwipe(false),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatDetailScreen(
                        imageUrl: imageUrl,
                        breedName: breedName,
                        breedDescription: breedDescription,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  ),
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
                    TextSpan(text: 'Dislikes: $dislikeCount |', style: const TextStyle(color: Colors.red)),
                    TextSpan(text: '| Likes: $likeCount', style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              LikeDislikeButtons(
                onLike: () => _handleButtonPress(true),
                onDislike: () => _handleButtonPress(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
