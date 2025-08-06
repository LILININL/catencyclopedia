import 'package:catencyclopedia/domain/usecases/get_breed_search.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'data/sources/remote_data_source.dart';
import 'domain/repositories/cat_repository.dart';
import 'domain/repositories/cat_repository_impl.dart';
import 'domain/usecases/get_cat_images.dart';
import 'domain/usecases/get_random_fact.dart';
import 'presentation/bloc/cat_bloc.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  final favoritesBox = await Hive.openBox('favorites');
  sl.registerLazySingleton<Box>(() => favoritesBox);

  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(headers: {'x-api-key': 'live_IYRCyeyGLPjd48Jgsk45Aak1mYnqT5LOAS0cAYBXR2iCIaEu0XNVxG3wfhEqgtY9'})));

  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource(sl<Dio>()));
  sl.registerLazySingleton<CatRepository>(() => CatRepositoryImpl(sl<RemoteDataSource>()));
  sl.registerLazySingleton<GetCatImages>(() => GetCatImages(sl<CatRepository>()));
  sl.registerLazySingleton<GetRandomFact>(() => GetRandomFact(sl<CatRepository>()));
  sl.registerLazySingleton(() => GetBreedSearch(sl<CatRepository>()));

  
  sl.registerFactory<CatBloc>(() => CatBloc(getImages: sl<GetCatImages>(), getFact: sl<GetRandomFact>(), getBreedSearch: sl<GetBreedSearch>()));
}
