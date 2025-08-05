import 'package:catencyclopedia/presentation/bloc/cat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat_breed.dart';
import '../bloc/cat_bloc.dart';

import '../bloc/cat_state.dart';

class DetailPage extends StatelessWidget {
  final String? image;
  final CatBreed? breed;

  const DetailPage({super.key, required this.breed, this.image});

  @override
  Widget build(BuildContext context) {
    print('DetailPage: ${breed?.imageUrl}');
    return Scaffold(
      appBar: AppBar(title: Text(breed?.name ?? 'Unknown')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: image ?? SizedBox.shrink().toString(),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Origin: ${breed?.origin ?? 'Unknown'}', style: const TextStyle(fontSize: 18)),
                  Text('Temperament: ${breed?.temperament ?? 'Unknown'}', style: const TextStyle(fontSize: 18)),
                  Text('Description: ${breed?.description ?? 'No description'}', style: const TextStyle(fontSize: 16)),
                  Text('Life Span: ${breed?.lifeSpan ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
                  Text('Weight: ${breed?.weight?.toString() ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
                  BlocBuilder<CatBloc, CatState>(
                    builder: (context, state) {
                      return Text('Random Fact: ${state.fact ?? 'No fact yet'}');
                    },
                  ),
                  ElevatedButton(onPressed: () => context.read<CatBloc>().add(GetFact()), child: const Text('Get Random Fact')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
