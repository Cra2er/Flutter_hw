import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cat_model.dart';

class CatStorage {
  static const _likedKey = 'liked_cats';
  static const _dislikeCountKey = 'dislike_count';

  final SharedPreferences prefs;

  CatStorage(this.prefs);

  Future<void> saveLikedCats(List<CatModel> cats, int dislikeCount) async {
    final encoded = cats.map((cat) => json.encode(cat.toJson())).toList();
    await prefs.setStringList(_likedKey, encoded);
    await prefs.setInt(_dislikeCountKey, dislikeCount);
  }

  Future<List<CatModel>> loadLikedCats() async {
    final List<String>? jsonList = prefs.getStringList(_likedKey);
    if (jsonList == null) return [];
    return jsonList
        .map((jsonStr) => CatModel.fromJson(json.decode(jsonStr)))
        .toList();
  }

  Future<int> loadDislikeCount() async {
    return prefs.getInt(_dislikeCountKey) ?? 0;
  }
}
