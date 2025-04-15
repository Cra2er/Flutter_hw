import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cat_model.dart';

class LikedCatsCubit extends Cubit<List<CatModel>> {
  final List<CatModel> _likedCats = [];
  final Set<String> _currentFilters = {};

  LikedCatsCubit() : super([]);

  void likeCat(CatModel cat) {
    _likedCats.add(cat);
    _applyMultiFilter();
  }

  void removeCat(CatModel cat) {
    _likedCats.remove(cat);
    _applyMultiFilter();
  }

  Set<String> get currentFilters => _currentFilters;

  List<String> get allBreeds =>
      _likedCats.map((cat) => cat.breedName).toSet().toList();

  void toggleFilter(String breed) {
    if (_currentFilters.contains(breed)) {
      _currentFilters.remove(breed);
    } else {
      _currentFilters.add(breed);
    }
    _applyMultiFilter();
  }

  void _applyMultiFilter() {
    if (_currentFilters.isEmpty) {
      emit(List.from(_likedCats));
    } else {
      emit(
        _likedCats
            .where((cat) => _currentFilters.contains(cat.breedName))
            .toList(),
      );
    }
  }

  void selectAllBreeds() {
    _currentFilters.clear();
    _currentFilters.addAll(allBreeds);
    _applyMultiFilter();
  }

  void clearFilters() {
    _currentFilters.clear();
    _applyMultiFilter();
  }
}
