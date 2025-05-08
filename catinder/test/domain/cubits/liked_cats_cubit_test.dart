import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:catinder/data/models/cat_model.dart';
import 'package:catinder/data/storage/cat_storage.dart';
import 'package:catinder/domain/cubits/liked_cats_cubit.dart';

class MockCatStorage extends Mock implements CatStorage {}

void main() {
  late LikedCatsCubit cubit;
  late MockCatStorage mockStorage;

  final testCat = CatModel(
    imageUrl: 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
    breedName: 'TestBreed',
    breedDescription: 'A friendly breed',
    likedAt: DateTime(2024, 1, 1),
  );


  setUp(() {
    mockStorage = MockCatStorage();

    when(() => mockStorage.loadLikedCats()).thenAnswer((_) async => []);
    when(() => mockStorage.loadDislikeCount()).thenAnswer((_) async => 0);
    when(() => mockStorage.saveLikedCats(any(), any())).thenAnswer((_) async {});

    cubit = LikedCatsCubit(mockStorage);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has empty likedCats and 0 dislikes', () {
    expect(cubit.state.likedCats, []);
    expect(cubit.state.dislikeCount, 0);
  });

  blocTest<LikedCatsCubit, LikedCatsState>(
    'emits state with liked cat after likeCat is called',
    build: () {
      when(() => mockStorage.loadLikedCats()).thenAnswer((_) async => []);
      when(() => mockStorage.loadDislikeCount()).thenAnswer((_) async => 0);
      when(() => mockStorage.saveLikedCats(any(), any()))
          .thenAnswer((_) async => {});
      return LikedCatsCubit(mockStorage);
    },
    act: (cubit) async {
      await cubit.likeCat(testCat);
    },
    skip: 1, // т.к. emit вызывается дважды (инициализация Cubit и вызов likeCat)
    expect: () => [
      isA<LikedCatsState>()
          .having((s) => s.likedCats.length, 'likedCats length', 1)
          .having((s) => s.likedCats.first.imageUrl, 'imageUrl', testCat.imageUrl),
    ],
    verify: (_) {
      verify(() => mockStorage.saveLikedCats(any(), any())).called(1);
    },
  );


  blocTest<LikedCatsCubit, LikedCatsState>(
    'emits state with incremented dislikeCount after removeCat is called',
    build: () => cubit,
    act: (cubit) async {
      await cubit.likeCat(testCat);
      await cubit.removeCat(testCat);
    },
    expect: () => [
      isA<LikedCatsState>().having((s) => s.likedCats.length, 'likedCats', 1),
      isA<LikedCatsState>()
          .having((s) => s.likedCats.length, 'likedCats', 0)
          .having((s) => s.dislikeCount, 'dislikeCount', 1),
    ],
    verify: (_) {
      verify(() => mockStorage.saveLikedCats(any(), any())).called(greaterThanOrEqualTo(1));
    },
  );
}
