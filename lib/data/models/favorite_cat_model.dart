import '../../domain/entities/favorite_cat.dart';

class FavoriteCatModel {
  final String id;
  final String imageUrl;
  final String breedName;
  final String? breedId;
  final DateTime addedAt;
  final String? localImagePath; // เพิ่ม: path ของรูปในเครื่อง
  final bool isDownloaded; // เพิ่ม: status การดาวน์โหลด
  
  // เพิ่มข้อมูลสำหรับการเก็บออฟไลน์
  final String? breedDescription; // คำอธิบายพันธุ์
  final String? origin; // ถิ่นกำเนิด
  final String? temperament; // นิสัย
  final String? lifeSpan; // อายุขัย
  final String? weight; // น้ำหนัก
  final int? energyLevel; // ระดับพลังงาน (1-5)
  final int? sheddingLevel; // ระดับการผลัด (1-5)
  final int? socialNeeds; // ความต้องการทางสังคม (1-5)
  final Map<String, dynamic>? additionalData; // ข้อมูลเพิ่มเติม

  FavoriteCatModel({
    required this.id,
    required this.imageUrl,
    required this.breedName,
    this.breedId,
    required this.addedAt,
    this.localImagePath,
    this.isDownloaded = false,
    this.breedDescription,
    this.origin,
    this.temperament,
    this.lifeSpan,
    this.weight,
    this.energyLevel,
    this.sheddingLevel,
    this.socialNeeds,
    this.additionalData,
  });

  /// Convert Entity to Model (for saving)
  factory FavoriteCatModel.fromEntity(FavoriteCat entity) {
    return FavoriteCatModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      breedName: entity.breedName,
      breedId: entity.breedId,
      addedAt: entity.addedAt,
      localImagePath: null, // จะอัพเดทภายหลังเมื่อดาวน์โหลดเสร็จ
      isDownloaded: false,
    );
  }

  /// Convert Entity to Model with breed data (for offline storage)
  factory FavoriteCatModel.fromEntityWithBreedData(
    FavoriteCat entity, {
    String? breedDescription,
    String? origin,
    String? temperament,
    String? lifeSpan,
    String? weight,
    int? energyLevel,
    int? sheddingLevel,
    int? socialNeeds,
    Map<String, dynamic>? additionalData,
  }) {
    return FavoriteCatModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      breedName: entity.breedName,
      breedId: entity.breedId,
      addedAt: entity.addedAt,
      localImagePath: null,
      isDownloaded: false,
      breedDescription: breedDescription,
      origin: origin,
      temperament: temperament,
      lifeSpan: lifeSpan,
      weight: weight,
      energyLevel: energyLevel,
      sheddingLevel: sheddingLevel,
      socialNeeds: socialNeeds,
      additionalData: additionalData,
    );
  }

  /// Convert to JSON (for Hive)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'breedName': breedName,
      'breedId': breedId,
      'addedAt': addedAt.millisecondsSinceEpoch,
      'localImagePath': localImagePath,
      'isDownloaded': isDownloaded,
      'breedDescription': breedDescription,
      'origin': origin,
      'temperament': temperament,
      'lifeSpan': lifeSpan,
      'weight': weight,
      'energyLevel': energyLevel,
      'sheddingLevel': sheddingLevel,
      'socialNeeds': socialNeeds,
      'additionalData': additionalData,
    };
  }

  /// Convert from JSON (for Hive)
  factory FavoriteCatModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCatModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      breedName: json['breedName'] ?? '',
      breedId: json['breedId'],
      addedAt: DateTime.fromMillisecondsSinceEpoch(json['addedAt'] ?? 0),
      localImagePath: json['localImagePath'],
      isDownloaded: json['isDownloaded'] ?? false,
      breedDescription: json['breedDescription'],
      origin: json['origin'],
      temperament: json['temperament'],
      lifeSpan: json['lifeSpan'],
      weight: json['weight'],
      energyLevel: json['energyLevel'],
      sheddingLevel: json['sheddingLevel'],
      socialNeeds: json['socialNeeds'],
      additionalData: json['additionalData'] != null 
          ? Map<String, dynamic>.from(json['additionalData']) 
          : null,
    );
  }

  /// Convert Model to Entity (for Domain Layer)
  FavoriteCat toEntity() {
    return FavoriteCat(
      id: id,
      imageUrl: imageUrl,
      breedName: breedName,
      breedId: breedId,
      addedAt: addedAt,
      breedDescription: breedDescription,
      origin: origin,
      temperament: temperament,
      lifeSpan: lifeSpan,
      weight: weight,
      energyLevel: energyLevel,
      sheddingLevel: sheddingLevel,
      socialNeeds: socialNeeds,
      additionalData: additionalData,
      isFullyLoaded: hasCompleteBreedData,
    );
  }

  /// Create copy with updated fields
  FavoriteCatModel copyWith({
    String? id,
    String? imageUrl,
    String? breedName,
    String? breedId,
    DateTime? addedAt,
    String? localImagePath,
    bool? isDownloaded,
    String? breedDescription,
    String? origin,
    String? temperament,
    String? lifeSpan,
    String? weight,
    int? energyLevel,
    int? sheddingLevel,
    int? socialNeeds,
    Map<String, dynamic>? additionalData,
  }) {
    return FavoriteCatModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      breedName: breedName ?? this.breedName,
      breedId: breedId ?? this.breedId,
      addedAt: addedAt ?? this.addedAt,
      localImagePath: localImagePath ?? this.localImagePath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      breedDescription: breedDescription ?? this.breedDescription,
      origin: origin ?? this.origin,
      temperament: temperament ?? this.temperament,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      weight: weight ?? this.weight,
      energyLevel: energyLevel ?? this.energyLevel,
      sheddingLevel: sheddingLevel ?? this.sheddingLevel,
      socialNeeds: socialNeeds ?? this.socialNeeds,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  /// Check if all breed data is available for offline use
  bool get hasCompleteBreedData {
    return breedDescription != null &&
           origin != null &&
           temperament != null &&
           lifeSpan != null &&
           weight != null &&
           isDownloaded;
  }

  /// Get offline display data
  Map<String, String> get offlineDisplayData {
    return {
      'Description': breedDescription ?? 'No description available',
      'Origin': origin ?? 'Unknown',
      'Temperament': temperament ?? 'Unknown',
      'Life Span': lifeSpan ?? 'Unknown',
      'Weight': weight ?? 'Unknown',
      'Energy Level': energyLevel != null ? '$energyLevel/5' : 'Unknown',
      'Shedding Level': sheddingLevel != null ? '$sheddingLevel/5' : 'Unknown',
      'Social Needs': socialNeeds != null ? '$socialNeeds/5' : 'Unknown',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteCatModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FavoriteCatModel{id: $id, breedName: $breedName, isDownloaded: $isDownloaded, hasCompleteData: $hasCompleteBreedData}';
  }
}
