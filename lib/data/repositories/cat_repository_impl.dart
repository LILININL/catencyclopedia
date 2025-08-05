import '../../domain/entities/cat_breed.dart';
import '../../domain/repositories/cat_repository.dart';
import '../sources/remote_data_source.dart';
import '../models/cat_image_model.dart';

abstract class CatRepository {
  Future<List<CatImageModel>> getCatImages();
  Future<String> getRandomFact();
}
