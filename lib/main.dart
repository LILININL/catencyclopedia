import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'locator.dart';
import 'presentation/bloc/favorite/favorite_bloc.dart';
import 'presentation/bloc/favorite/favorite_event.dart';
import 'presentation/bloc/get/cat_bloc.dart';
import 'presentation/bloc/get/cat_event.dart';
import 'core/theme/app_theme.dart';
import 'core/services/translation_service.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initLocator();
  await TranslationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatBloc>(create: (_) => sl<CatBloc>()..add(LoadImages())),
        BlocProvider<FavoriteBloc>(create: (_) => sl<FavoriteBloc>()..add(LoadFavorites())),
      ],
      child: MaterialApp.router(title: 'Cat Encyclopedia', theme: AppTheme.theme, routerConfig: AppRouter.router),
    );
  }
}
