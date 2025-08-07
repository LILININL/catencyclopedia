import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RemoteCatDataSource {
  final Dio dio;

  RemoteCatDataSource(this.dio) {
    dio.options.headers['x-api-key'] = ApiConstants.apiKey;
    dio.options.connectTimeout = Duration(seconds: AppConfig.connectTimeoutSeconds);
    dio.options.receiveTimeout = Duration(seconds: AppConfig.networkTimeoutSeconds);
    
    // เพิ่ม interceptor สำหรับ debug logging
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => debugPrint('[DIO] $object'),
      ));
    }
  }

  Future<List<CatBreedModel>> getCatImages({int page = ApiConstants.defaultPage, int limit = ApiConstants.defaultLimit, String? breedIds}) async {
    try {
      debugPrint('[RemoteCatDataSource] Starting getCatImages - page: $page, limit: $limit, breedIds: $breedIds');
      
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

      final url = '${ApiConstants.baseUrl}${ApiConstants.imagesEndpoint}';
      debugPrint('[RemoteCatDataSource] Making request to: $url');
      debugPrint('[RemoteCatDataSource] Query parameters: $queryParameters');
      debugPrint('[RemoteCatDataSource] Headers: ${dio.options.headers}');

      final response = await dio.get(url, queryParameters: queryParameters);

      debugPrint('[RemoteCatDataSource] Response status: ${response.statusCode}');
      debugPrint('[RemoteCatDataSource] Response data length: ${response.data?.length ?? 0}');

      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        final result = json.map((item) => CatBreedModel.fromJson(item)).toList();
        debugPrint('[RemoteCatDataSource] Successfully parsed ${result.length} cat images');
        return result;
      } else {
        final errorMsg = 'Failed to load images: ${response.statusCode} - ${response.statusMessage}';
        debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      final errorMsg = 'Network error (DioException): ${e.type} - ${e.message}';
      debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
      debugPrint('[RemoteCatDataSource] Error response: ${e.response?.data}');
      throw Exception(errorMsg);
    } catch (e) {
      final errorMsg = 'Unknown error: $e';
      debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
      throw Exception(errorMsg);
    }
  }

  Future<String> getRandomFact() async {
    try {
      debugPrint('[RemoteCatDataSource] Starting getRandomFact');
      
      final response = await dio.get('https://catfact.ninja/fact');
      
      debugPrint('[RemoteCatDataSource] Fact response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final fact = response.data['fact'] as String;
        debugPrint('[RemoteCatDataSource] Successfully got fact: ${fact.substring(0, 50)}...');
        return fact;
      } else {
        final errorMsg = 'Failed to load fact: ${response.statusCode} - ${response.statusMessage}';
        debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      final errorMsg = 'Network error getting fact (DioException): ${e.type} - ${e.message}';
      debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      final errorMsg = 'Unknown error getting fact: $e';
      debugPrint('[RemoteCatDataSource] ERROR: $errorMsg');
      throw Exception(errorMsg);
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
