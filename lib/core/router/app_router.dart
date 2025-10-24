import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/favorites_page.dart';
import '../../presentation/pages/detail_page.dart';
import '../../presentation/bloc/favorite/favorite_bloc.dart';
import '../../domain/entities/cat_breed.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: HomePage.routeName,
    routes: [
      // Home route
      GoRoute(path: HomePage.routeName, name: 'home', builder: (context, state) => const HomePage()),

      // Favorites route
      GoRoute(
        path: FavoritesPage.routeName,
        name: 'favorites',
        builder: (context, state) => BlocProvider<FavoriteBloc>.value(value: context.read<FavoriteBloc>(), child: const FavoritesPage()),
      ),

      // Detail route with optional parameters
      GoRoute(
        path: DetailPage.routeName,
        name: 'detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final breed = extra?['breed'] as CatBreed?;
          final image = extra?['image'] as String?;

          return DetailPage(breed: breed, image: image);
        },
      ),
    ],
  );
  static GoRouter get router => _router;
}
