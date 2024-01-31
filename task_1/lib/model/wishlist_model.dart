class WishlistModel {
  final int id;
  final int userId;
  final String dogId;
  final String name;
  final String referenceImageId;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.dogId,
    required this.name,
    required this.referenceImageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dogId': dogId,
      'name': name,
      'referenceImageId': referenceImageId
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> dogData) {
    return WishlistModel(
        id: dogData["id"],
        userId: dogData["userId"],
        dogId: dogData["dogId"],
        name: dogData["name"],
        referenceImageId: dogData["referenceImageId"]);
  }
}
