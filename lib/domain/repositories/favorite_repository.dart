import 'package:dartz/dartz.dart';
import '../entities/favorite_cat.dart';

abstract class FavoriteRepository {
  /// เพิ่มรูปแมวไปยังรายการโปรด
  Future<Either<Exception, Unit>> addFavorite(FavoriteCat favoriteCat);

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
}
