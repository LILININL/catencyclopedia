import 'package:catencyclopedia/presentation/bloc/cat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat_breed.dart';
import '../bloc/cat_bloc.dart';
import '../bloc/cat_state.dart';

class DetailPage extends StatelessWidget {
  final CatBreed breed;

  const DetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatBloc, CatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(breed.name)),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: breed.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 100),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Origin: ${breed.origin}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Temperament: ${breed.temperament}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Description: ${breed.description}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      if (state.fact != null) Text('Random Fact: ${state.fact}'),
                      ElevatedButton(onPressed: () => context.read<CatBloc>().add(GetFact()), child: const Text('Get Random Fact')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
