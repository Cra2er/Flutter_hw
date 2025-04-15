import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class CatService {
  static const String apiKey = 'YOUR_API_KEY';

  static Future<Map<String, String>?> fetchRandomCat() async {
    final breedResponse = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/breeds?api_key=$apiKey'),
    );

    if (breedResponse.statusCode == 200) {
      final List<dynamic> breeds = json.decode(breedResponse.body);
      if (breeds.isNotEmpty) {
        final randomBreed = breeds[Random().nextInt(breeds.length)];
        final breedId = randomBreed['id'];
        final breedName = randomBreed['name'];
        final breedDescription =
            randomBreed['description'] ?? 'Описание отсутствует';

        final imageResponse = await http.get(
          Uri.parse(
            'https://api.thecatapi.com/v1/images/search?breed_ids=$breedId&limit=1&api_key=$apiKey',
          ),
        );

        if (imageResponse.statusCode == 200) {
          final List<dynamic> imageData = json.decode(imageResponse.body);
          if (imageData.isNotEmpty) {
            return {
              'imageUrl': imageData[0]['url'],
              'breedName': breedName,
              'breedDescription': breedDescription,
            };
          }
        }
      }
    }
    return null;
  }
}
