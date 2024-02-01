class WishlistModel {
  final int id;
  final String userId;
  final String dogId;
  final String name;
  final String imageUrl;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.dogId,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dogId': dogId,
      'name': name,
      'imageUrl': imageUrl
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> dogData) {
    return WishlistModel(
        id: dogData["id"],
        userId: dogData["userId"],
        dogId: dogData["dogId"],
        name: dogData["name"],
        imageUrl: dogData["imageUrl"]);
  }
}
