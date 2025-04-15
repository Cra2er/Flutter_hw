class CatModel {
  final String imageUrl;
  final String breedName;
  final DateTime likedAt;
  final String breedDescription;

  CatModel({
    required this.imageUrl,
    required this.breedName,
    required this.likedAt,
    required this.breedDescription,
  });

  String formattedDate() {
    return '${likedAt.day}/${likedAt.month}/${likedAt.year}';
  }
}
