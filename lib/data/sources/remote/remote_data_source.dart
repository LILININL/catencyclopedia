import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:dio/dio.dart';

class RemoteCatDataSource {
  final Dio dio;

  RemoteCatDataSource(this.dio) {
    dio.options.headers['x-api-key'] = ApiConstants.apiKey;
  }

  Future<List<CatBreedModel>> getCatImages({int page = ApiConstants.defaultPage, int limit = ApiConstants.defaultLimit, String? breedIds}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'size': ApiConstants.imageSize,
        'mime_types': ApiConstants.mimeTypes,
        'format': ApiConstants.format,
        'has_breeds': ApiConstants.hasBreeds,
        'order': ApiConstants.order,
        'page': page,
        'limit': limit,
      };

      if (breedIds != null && breedIds.isNotEmpty) {
        queryParameters['breed_ids'] = breedIds;
      }

      final response = await dio.get('${ApiConstants.baseUrl}${ApiConstants.imagesEndpoint}', queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return json.map((item) => CatBreedModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> getRandomFact() async {
    try {
      final response = await dio.get('https://catfact.ninja/fact');
      if (response.statusCode == 200) {
        return response.data['fact'] as String;
      } else {
        throw Exception('Failed to load fact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Breed>> searchBreedsData(String query) async {
    try {
      final response = await dio.get('https://api.thecatapi.com/v1/breeds/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return json.map((item) => Breed.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<CatBreedModel>> searchBreeds(String query) async {
    try {
      final response = await dio.get('https://api.thecatapi.com/v1/breeds/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return json.map((item) => CatBreedModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
