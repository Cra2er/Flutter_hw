import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cat_model.dart';
import '../../data/storage/cat_storage.dart';

class LikedCatsState {
  final List<CatModel> likedCats;
  final int dislikeCount;

  const LikedCatsState({required this.likedCats, required this.dislikeCount});
}

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final CatStorage storage;
  final List<CatModel> _likedCats = [];
  final Set<String> _currentFilters = {};

  int _dislikeCount = 0;

  LikedCatsCubit(this.storage)
    : super(const LikedCatsState(likedCats: [], dislikeCount: 0)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final loadedCats = await storage.loadLikedCats();
    _likedCats.addAll(loadedCats);
    _dislikeCount = await storage.loadDislikeCount();
    _applyMultiFilter();
  }

  Future<void> likeCat(CatModel cat) async {
    _likedCats.add(cat);
    await _save();
    _applyMultiFilter();
  }

  Future<void> removeCat(CatModel cat) async {
    _likedCats.remove(cat);
    _dislikeCount++;
    await _save();
    _applyMultiFilter();
  }

  Future<void> _save() async {
    await storage.saveLikedCats(_likedCats, _dislikeCount);
  }

  void _applyMultiFilter() {
    final filtered =
        _currentFilters.isEmpty
            ? List<CatModel>.from(_likedCats)
            : _likedCats
                .where((cat) => _currentFilters.contains(cat.breedName))
                .toList();

    emit(LikedCatsState(likedCats: filtered, dislikeCount: _dislikeCount));
  }

  int getDislikeCount() => _dislikeCount;

  List<String> get allBreeds =>
      _likedCats.map((cat) => cat.breedName).toSet().toList();

  Set<String> get currentFilters => _currentFilters;

  void toggleFilter(String breed) {
    if (_currentFilters.contains(breed)) {
      _currentFilters.remove(breed);
    } else {
      _currentFilters.add(breed);
    }
    _applyMultiFilter();
  }

  void selectAllBreeds() {
    _currentFilters
      ..clear()
      ..addAll(allBreeds);
    _applyMultiFilter();
  }

  void clearFilters() {
    _currentFilters.clear();
    _applyMultiFilter();
  }
}
