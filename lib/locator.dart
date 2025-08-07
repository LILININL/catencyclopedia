import 'package:catencyclopedia/data/sources/local/local_data_source.dart';
import 'package:catencyclopedia/domain/usecases/cat/get_breed_search.dart';
import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

import 'data/sources/remote/remote_data_source.dart';
import 'domain/repositories/cat_repository.dart';
import 'domain/repositories/cat_repository_impl.dart';
import 'domain/usecases/cat/get_cat_images.dart';
import 'domain/usecases/cat/get_random_fact.dart';
import 'presentation/bloc/get/cat_bloc.dart';

// Favorite imports
import 'data/sources/local/favorite_local_data_source.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'domain/repositories/favorite_repository.dart';
import 'domain/usecases/favorite/add_favorite.dart';
import 'domain/usecases/favorite/add_favorite_with_breed_data.dart';
import 'domain/usecases/favorite/get_favorite_by_id.dart';
import 'domain/usecases/favorite/remove_favorite.dart';
import 'domain/usecases/favorite/get_favorites.dart';
import 'domain/usecases/favorite/is_favorite.dart';
import 'domain/usecases/favorite/update_favorite.dart';
import 'domain/usecases/favorite/clear_favorites.dart';
import 'presentation/bloc/favorite/favorite_bloc.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  final favoritesBox = await Hive.openBox('favorites');
  sl.registerLazySingleton<Box>(() => favoritesBox);

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    
    // กำหนดค่า timeout และ headers
    dio.options.connectTimeout = Duration(seconds: AppConfig.connectTimeoutSeconds);
    dio.options.receiveTimeout = Duration(seconds: AppConfig.networkTimeoutSeconds);
    dio.options.headers['x-api-key'] = ApiConstants.apiKey;
    
    // เพิ่ม debug logging สำหรับ development
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
        logPrint: (object) => debugPrint('[DIO_SETUP] $object'),
      ));
    }
    
    debugPrint('[DIO_SETUP] Dio configured with API key: ${ApiConstants.apiKey.substring(0, 10)}...');
    
    return dio;
  });

  // Cat Data Sources & Repository
  sl.registerLazySingleton<RemoteCatDataSource>(() => RemoteCatDataSource(sl<Dio>()));
  sl.registerLazySingleton<LocalCatDataSource>(() => LocalCatDataSource(sl<Box>()));
  sl.registerLazySingleton<CatRepository>(() => CatRepositoryImpl(sl<RemoteCatDataSource>(), sl<LocalCatDataSource>()));
  
  // Cat Use Cases
  sl.registerLazySingleton<GetCatImages>(() => GetCatImages(sl<CatRepository>()));
  sl.registerLazySingleton<GetRandomFact>(() => GetRandomFact(sl<CatRepository>()));
  sl.registerLazySingleton(() => GetBreedSearch(sl<CatRepository>()));

  // Favorite Data Sources & Repository
  final favoriteBox = await Hive.openBox<Map<dynamic, dynamic>>('favorite_cats');
  sl.registerLazySingleton<FavoriteLocalDataSource>(() => FavoriteLocalDataSourceImpl(hiveBox: favoriteBox, dio: sl<Dio>()));
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(localDataSource: sl<FavoriteLocalDataSource>()));
  
  // Favorite Use Cases
  sl.registerLazySingleton<AddFavorite>(() => AddFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<AddFavoriteWithBreedData>(() => AddFavoriteWithBreedData(sl<FavoriteRepository>()));
  sl.registerLazySingleton<GetFavoriteById>(() => GetFavoriteById(sl<FavoriteRepository>()));
  sl.registerLazySingleton<RemoveFavorite>(() => RemoveFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<GetFavorites>(() => GetFavorites(sl<FavoriteRepository>()));
  sl.registerLazySingleton<IsFavorite>(() => IsFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<UpdateFavorite>(() => UpdateFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<ClearFavorites>(() => ClearFavorites(sl<FavoriteRepository>()));

  // BLoCs
  sl.registerFactory<CatBloc>(() => CatBloc(getImages: sl<GetCatImages>(), getFact: sl<GetRandomFact>(), getBreedSearch: sl<GetBreedSearch>()));
  sl.registerFactory<FavoriteBloc>(() => FavoriteBloc(
    addFavorite: sl<AddFavorite>(),
    addFavoriteWithBreedData: sl<AddFavoriteWithBreedData>(),
    removeFavorite: sl<RemoveFavorite>(),
    getFavorites: sl<GetFavorites>(),
    isFavorite: sl<IsFavorite>(),
    updateFavorite: sl<UpdateFavorite>(),
    clearFavorites: sl<ClearFavorites>(),
  ));
}
