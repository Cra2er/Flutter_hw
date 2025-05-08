class CatModel {
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final DateTime likedAt;

  CatModel({
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.likedAt,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'breedName': breedName,
    'breedDescription': breedDescription,
    'likedAt': likedAt.toIso8601String(),
  };

  factory CatModel.fromJson(Map<String, dynamic> json) => CatModel(
    imageUrl: json['imageUrl'],
    breedName: json['breedName'],
    breedDescription: json['breedDescription'],
    likedAt: DateTime.parse(json['likedAt']),
  );

  String formattedDate() {
    return '${likedAt.day}.${likedAt.month}.${likedAt.year}';
  }
}
