import '../../domain/entities/favorite_cat.dart';

class FavoriteCatModel {
  final String id;
  final String imageUrl;
  final String breedName;
  final String? breedId;
  final DateTime addedAt;
  final String? localImagePath;  // เพิ่ม: path ของรูปในเครื่อง
  final bool isDownloaded;       // เพิ่ม: status การดาวน์โหลด

  FavoriteCatModel({
    required this.id,
    required this.imageUrl,
    required this.breedName,
    this.breedId,
    required this.addedAt,
    this.localImagePath,
    this.isDownloaded = false,
  });

  /// Convert Entity to Model (for saving)
  factory FavoriteCatModel.fromEntity(FavoriteCat entity) {
    return FavoriteCatModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      breedName: entity.breedName,
      breedId: entity.breedId,
      addedAt: entity.addedAt,
      localImagePath: null,  // จะอัพเดทภายหลังเมื่อดาวน์โหลดเสร็จ
      isDownloaded: false,
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
  }) {
    return FavoriteCatModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      breedName: breedName ?? this.breedName,
      breedId: breedId ?? this.breedId,
      addedAt: addedAt ?? this.addedAt,
      localImagePath: localImagePath ?? this.localImagePath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
