import 'cat_breed.dart';

class FavoriteCat {
  final String id;
  final String imageUrl;
  final String breedName;
  final String? breedId;
  final DateTime addedAt;
  
  // เพิ่มข้อมูลสำหรับการเก็บออฟไลน์
  final String? breedDescription;
  final String? origin;
  final String? temperament;
  final String? lifeSpan;
  final String? weight;
  final int? energyLevel;
  final int? sheddingLevel;
  final int? socialNeeds;
  final Map<String, dynamic>? additionalData;
  final bool isFullyLoaded; // ระบุว่าข้อมูลครบถ้วนหรือไม่

  FavoriteCat({
    required this.id,
    required this.imageUrl,
    required this.breedName,
    this.breedId,
    required this.addedAt,
    this.breedDescription,
    this.origin,
    this.temperament,
    this.lifeSpan,
    this.weight,
    this.energyLevel,
    this.sheddingLevel,
    this.socialNeeds,
    this.additionalData,
    this.isFullyLoaded = false,
  });

  /// Convert FavoriteCat to CatBreed for navigation - CENTRALIZED CONVERSION
  CatBreed toCatBreed() {
    return CatBreed(
      id: breedId ?? id,
      name: breedName,
      url: imageUrl,
      imageUrl: imageUrl,
      description: breedDescription,
      origin: origin,
      temperament: temperament,
      lifeSpan: lifeSpan,
      energyLevel: energyLevel,
      sheddingLevel: sheddingLevel,
      socialNeeds: socialNeeds,
    );
  }

  // 1. copyWith method
  FavoriteCat copyWith({
    String? id,
    String? imageUrl,
    String? breedName,
    String? breedId,
    DateTime? addedAt,
    String? breedDescription,
    String? origin,
    String? temperament,
    String? lifeSpan,
    String? weight,
    int? energyLevel,
    int? sheddingLevel,
    int? socialNeeds,
    Map<String, dynamic>? additionalData,
    bool? isFullyLoaded,
  }) {
    return FavoriteCat(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      breedName: breedName ?? this.breedName,
      breedId: breedId ?? this.breedId,
      addedAt: addedAt ?? this.addedAt,
      breedDescription: breedDescription ?? this.breedDescription,
      origin: origin ?? this.origin,
      temperament: temperament ?? this.temperament,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      weight: weight ?? this.weight,
      energyLevel: energyLevel ?? this.energyLevel,
      sheddingLevel: sheddingLevel ?? this.sheddingLevel,
      socialNeeds: socialNeeds ?? this.socialNeeds,
      additionalData: additionalData ?? this.additionalData,
      isFullyLoaded: isFullyLoaded ?? this.isFullyLoaded,
    );
  }

  // 2. toMap method (สำหรับ JSON/SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'breedName': breedName,
      'breedId': breedId,
      'addedAt': addedAt.millisecondsSinceEpoch,
      'breedDescription': breedDescription,
      'origin': origin,
      'temperament': temperament,
      'lifeSpan': lifeSpan,
      'weight': weight,
      'energyLevel': energyLevel,
      'sheddingLevel': sheddingLevel,
      'socialNeeds': socialNeeds,
      'additionalData': additionalData,
      'isFullyLoaded': isFullyLoaded,
    };
  }

  // 3. fromMap method
  factory FavoriteCat.fromMap(Map<String, dynamic> map) {
    return FavoriteCat(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      breedName: map['breedName'] ?? '',
      breedId: map['breedId'],
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['addedAt'] ?? 0),
      breedDescription: map['breedDescription'],
      origin: map['origin'],
      temperament: map['temperament'],
      lifeSpan: map['lifeSpan'],
      weight: map['weight'],
      energyLevel: map['energyLevel'],
      sheddingLevel: map['sheddingLevel'],
      socialNeeds: map['socialNeeds'],
      additionalData: map['additionalData'] != null 
          ? Map<String, dynamic>.from(map['additionalData']) 
          : null,
      isFullyLoaded: map['isFullyLoaded'] ?? false,
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
