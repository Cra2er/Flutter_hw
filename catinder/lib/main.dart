import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/cubits/liked_cats_cubit.dart';
import 'presentation/screens/cat_screen.dart';

void main() {
  runApp(const CatApp());
}

class CatApp extends StatelessWidget {
  const CatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LikedCatsCubit>(create: (context) => LikedCatsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cat Swipe',
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const CatScreen(),
      ),
    );
  }
}
