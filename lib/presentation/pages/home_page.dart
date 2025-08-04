import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../locator.dart';
import '../bloc/cat_bloc.dart';
import '../bloc/cat_event.dart' hide CatState;
import '../bloc/cat_state.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatBloc>(
      create: (_) => sl<CatBloc>()..add(LoadBreeds()),
      child: Builder(
        builder: (blocContext) => Scaffold(
          appBar: AppBar(title: const Text('Cat Encyclopedia')),
          body: BlocBuilder<CatBloc, CatState>(
            builder: (context, state) {
              if (state.isLoading) return const Center(child: CircularProgressIndicator());
              if (state.error != null) return Center(child: Text(state.error!));
              return ListView.builder(
                itemCount: state.breeds?.length ?? 0,
                itemBuilder: (context, index) {
                  final breed = state.breeds![index];
                  print('Image URL: ${breed.imageUrl}'); // Debugging line
                  print('Breed ID: ${breed.id.length}'); // Debugging line
                  print('Breed Name: ${breed.name}'); // Debugging line
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(imageUrl: '${breed.imageUrl}/${index + 1}', fit: BoxFit.cover, errorWidget: (context, url, error) => const Icon(Icons.error)),
                    ),
                    title: Text(breed.name),
                    onTap: () => Navigator.push(
                      blocContext,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<CatBloc>.value(
                          value: blocContext.read<CatBloc>(),
                          child: DetailPage(breed: breed),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(onPressed: () => blocContext.read<CatBloc>().add(GetFact()), child: const Icon(Icons.lightbulb)),
        ),
      ),
    );
  }
}
