import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/favorite_cat_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> addFavorite(FavoriteCatModel favorite);
  Future<void> updateFavorite(FavoriteCatModel favorite);
  Future<void> removeFavorite(String catId);
  Future<List<FavoriteCatModel>> getFavorites();
  Future<bool> isFavorite(String catId);
  Future<void> clearFavorites();
  Future<String?> downloadAndSaveImage(String imageUrl, String catId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final Box<Map<dynamic, dynamic>> hiveBox;
  final Dio dio;

  FavoriteLocalDataSourceImpl({required this.hiveBox, required this.dio});

  @override
  Future<void> addFavorite(FavoriteCatModel favorite) async {
    // เช็คว่ามีอยู่แล้วไหม
    if (await isFavorite(favorite.id)) return;

    // บันทึกข้อมูลลง Hive ก่อน
    await hiveBox.put(favorite.id, favorite.toJson());

    // ดาวน์โหลดรูปใน background
    _downloadImageInBackground(favorite);
  }

  @override
  Future<void> updateFavorite(FavoriteCatModel favorite) async {
    await hiveBox.put(favorite.id, favorite.toJson());
  }

  @override
  Future<void> removeFavorite(String catId) async {
    final favorite = await _getFavoriteById(catId);
    if (favorite != null && favorite.localImagePath != null) {
      // ลบรูปจากเครื่อง
      try {
        final file = File(favorite.localImagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting image file: $e');
      }
    }
    await hiveBox.delete(catId);
  }

  @override
  Future<List<FavoriteCatModel>> getFavorites() async {
    try {
      final List<FavoriteCatModel> favorites = [];
      for (final key in hiveBox.keys) {
        final data = hiveBox.get(key);
        if (data != null) {
          final favorite = FavoriteCatModel.fromJson(Map<String, dynamic>.from(data));
          favorites.add(favorite);
        }
      }
      // เรียงตามวันที่เพิ่ม (ใหม่สุดก่อน)
      favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      return favorites;
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  @override
  Future<bool> isFavorite(String catId) async {
    return hiveBox.containsKey(catId);
  }

  @override
  Future<void> clearFavorites() async {
    // ลบรูปทั้งหมดก่อน
    final favorites = await getFavorites();
    for (final favorite in favorites) {
      if (favorite.localImagePath != null) {
        try {
          final file = File(favorite.localImagePath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('Error deleting image file: $e');
        }
      }
    }
    await hiveBox.clear();
  }

  @override
  Future<String?> downloadAndSaveImage(String imageUrl, String catId) async {
    try {
      final response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String favoritesDir = '${appDocDir.path}/favorites';
      final Directory directory = Directory(favoritesDir);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final String filePath = '$favoritesDir/${catId}.jpg';
      final File file = File(filePath);
      await file.writeAsBytes(response.data);

      return filePath;
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  Future<FavoriteCatModel?> _getFavoriteById(String catId) async {
    final data = hiveBox.get(catId);
    if (data != null) {
      return FavoriteCatModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  void _downloadImageInBackground(FavoriteCatModel favorite) async {
    try {
      final localPath = await downloadAndSaveImage(favorite.imageUrl, favorite.id);
      if (localPath != null) {
        // อัพเดทข้อมูลด้วย local path
        final updatedFavorite = favorite.copyWith(localImagePath: localPath, isDownloaded: true);
        await updateFavorite(updatedFavorite);
      }
    } catch (e) {
      print('Background image download failed: $e');
    }
  }
}
