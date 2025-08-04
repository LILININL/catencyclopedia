import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'data/models/cat_breed_model.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'data/sources/remote_data_source.dart';
import 'domain/repositories/cat_repository.dart';
import 'domain/usecases/get_cat_breeds.dart';
import 'domain/usecases/get_random_fact.dart';
import 'presentation/bloc/cat_bloc.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  final favoritesBox = await Hive.openBox('favorites');

  // External (http client)
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data Sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource(sl<http.Client>()));

  // Repositories
  sl.registerLazySingleton<CatRepository>(() => CatRepositoryImpl(sl<RemoteDataSource>()));

  // Use Cases
  sl.registerLazySingleton<GetCatBreeds>(() => GetCatBreeds(sl<CatRepository>()));
  sl.registerLazySingleton<GetRandomFact>(() => GetRandomFact(sl<CatRepository>()));

  // BLoC
  sl.registerFactory<CatBloc>(() => CatBloc(getBreeds: sl<GetCatBreeds>(), getFact: sl<GetRandomFact>()));
}
