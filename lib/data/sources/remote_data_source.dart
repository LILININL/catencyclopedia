import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:dio/dio.dart';

class RemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio) {
    dio.options.headers['x-api-key'] = 'live_IYRCyeyGLPjd48Jgsk45Aak1mYnqT5LOAS0cAYBXR2iCIaEu0XNVxG3wfhEqgtY9';
  }
  Future<List<CatBreedModel>> getCatImages({int page = 0, int limit = 100, String? breedIds}) async {
    try {
      final Map<String, dynamic> queryParameters = {'size': 'med', 'mime_types': 'jpg', 'format': 'json', 'has_breeds': true, 'order': 'RANDOM', 'page': page, 'limit': limit};
      if (breedIds != null && breedIds.isNotEmpty) {
        queryParameters['breed_ids'] = breedIds;
      }
      final response = await dio.get('https://api.thecatapi.com/v1/images/search', queryParameters: queryParameters);
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
