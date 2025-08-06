class FavoriteCat {
  final String id;
  final String imageUrl;
  final String breedName;
  final String? breedId;
  final DateTime addedAt;

  FavoriteCat({required this.id, required this.imageUrl, required this.breedName, this.breedId, required this.addedAt});

  // 1. copyWith method
  FavoriteCat copyWith({String? id, String? imageUrl, String? breedName, String? breedId, DateTime? addedAt}) {
    return FavoriteCat(id: id ?? this.id, imageUrl: imageUrl ?? this.imageUrl, breedName: breedName ?? this.breedName, breedId: breedId ?? this.breedId, addedAt: addedAt ?? this.addedAt);
  }

  // 2. toMap method (สำหรับ JSON/SharedPreferences)
  Map<String, dynamic> toMap() {
    return {'id': id, 'imageUrl': imageUrl, 'breedName': breedName, 'breedId': breedId, 'addedAt': addedAt.millisecondsSinceEpoch};
  }

  // 3. fromMap method
  factory FavoriteCat.fromMap(Map<String, dynamic> map) {
    return FavoriteCat(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      breedName: map['breedName'] ?? '',
      breedId: map['breedId'],
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['addedAt'] ?? 0),
    );
  }

  // 4. == operator และ hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteCat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
