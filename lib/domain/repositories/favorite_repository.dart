import 'package:dartz/dartz.dart';
import '../entities/favorite_cat.dart';

abstract class FavoriteRepository {
  /// เพิ่มรูปแมวไปยังรายการโปรด
  Future<Either<Exception, Unit>> addFavorite(FavoriteCat favoriteCat);

  /// เพิ่มรูปแมวไปยังรายการโปรดพร้อมข้อมูลครบถ้วน (สำหรับออฟไลน์)
  Future<Either<Exception, Unit>> addFavoriteWithBreedData(
    FavoriteCat favoriteCat, {
    String? breedDescription,
    String? origin,
    String? temperament,
    String? lifeSpan,
    String? weight,
    int? energyLevel,
    int? sheddingLevel,
    int? socialNeeds,
    Map<String, dynamic>? additionalData,
  });

  /// อัพเดทข้อมูลรูปแมวในรายการโปรด
  Future<Either<Exception, Unit>> updateFavorite(FavoriteCat favoriteCat);

  /// ลบรูปแมวออกจากรายการโปรด
  Future<Either<Exception, Unit>> removeFavorite(String catId);

  /// ดึงรายการแมวที่ชื่นชอบทั้งหมด
  Future<Either<Exception, List<FavoriteCat>>> getFavorites();

  /// เช็คว่ารูปแมวนี้อยู่ในรายการโปรดไหม
  Future<Either<Exception, bool>> isFavorite(String catId);

  /// ล้างรายการโปรดทั้งหมด
  Future<Either<Exception, Unit>> clearFavorites();

  /// ดึงข้อมูลแมวโปรดสำหรับแสดงผลออฟไลน์
  Future<Either<Exception, FavoriteCat?>> getFavoriteById(String catId);
}
