import '../bloc/cat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../locator.dart';
import '../bloc/cat_bloc.dart';
import '../bloc/cat_state.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatBloc>(
      create: (_) => sl<CatBloc>()..add(LoadImages()),
      child: Builder(
        builder: (blocContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Cat Encyclopedia'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ค้นหาพันธุ์แมว...',
                    suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => blocContext.read<CatBloc>().add(SearchBreeds(_searchController.text))),
                  ),
                  onSubmitted: (query) => blocContext.read<CatBloc>().add(SearchBreeds(query)),
                ),
              ),
            ),
          ),
          body: BlocBuilder<CatBloc, CatState>(
            builder: (context, state) {
              if (state.isLoading && (state.images?.isEmpty ?? true)) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text(state.error!));
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification && notification.metrics.extentAfter < 300 && !state.isLoading && !state.hasReachedMax) {
                    context.read<CatBloc>().add(LoadMoreImages());
                    return true;
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (state.images?.length ?? 0) + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= (state.images?.length ?? 0)) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final image = state.images![index];
                    final breed = image.breeds?.isNotEmpty == true ? image.breeds![0] : null;
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(imageUrl: image.url ?? 'https://placecats.com/200/200', fit: BoxFit.cover, errorWidget: (context, url, error) => const Icon(Icons.error)),
                      ),
                      title: Text(breed?.name ?? 'Unknown'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<CatBloc>.value(
                            value: context.read<CatBloc>(),
                            child: DetailPage(breed: breed!, image: image.url),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(onPressed: () => blocContext.read<CatBloc>().add(RefreshImages()), child: const Icon(Icons.refresh)),
        ),
      ),
    );
  }
}
