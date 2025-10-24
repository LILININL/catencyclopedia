import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import '../../domain/entities/cat_breed.dart';
import '../bloc/get/cat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../bloc/get/cat_bloc.dart';
import '../bloc/get/cat_state.dart';
import '../widgets/favorite_button.dart';
import '../widgets/filter_dialog.dart';
import 'favorites_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedOrigin;
  String _searchQuery = '';
  bool _isNavigating = false; // ป้องกันการ navigate ซ้ำ

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final gridColumnCount = isTablet ? 4 : 2;

    final catOrange = const Color(0xFFFFB74D);
    final catCream = const Color(0xFFFFF3E0);
    final catBrown = const Color(0xFF8D5524);

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: catOrange,
        scaffoldBackgroundColor: catCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB74D),
          foregroundColor: Colors.brown,
          elevation: 2,
          iconTheme: IconThemeData(color: Color(0xFF8D5524)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: catOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF4E342E)),
          titleMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D5524)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.pets, color: Color(0xFF8D5524)),
              SizedBox(width: 8),
              const Text('Cat Encyclopedia'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              tooltip: 'รายการโปรด',
              onPressed: () async {
                context.go(FavoritesPage.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'กรองพันธุ์',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider<CatBloc>.value(
                    value: context.read<CatBloc>(),
                    child: FilterDialog(
                      state: context.read<CatBloc>().state,
                      onSelected: (origin) {
                        setState(() {
                          _selectedOrigin = origin;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'ค้นหาพันธุ์แมว... เช่น Bengal, Persian',
                  prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 228, 142, 62)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  filled: true,
                  fillColor: Color.fromARGB(255, 252, 252, 252),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<CatBloc, CatState>(
          builder: (context, state) {
            if (state.isLoading && (state.images?.isEmpty ?? true)) {
              return const Center(child: CircularProgressIndicator());
            }

            // ถ้ามี error (ไม่สามารถเรียก API ได้) ให้ไปหน้า Favorites
            if (state.error != null) {
              print('[HomePage] API Error detected: ${state.error} - Redirecting to Favorites');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go(FavoritesPage.routeName);
              });
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: catOrange),
                    const SizedBox(height: 16),
                    Text('เปลี่ยนไปหน้ารายการโปรด...', style: TextStyle(color: catBrown, fontSize: 16)),
                  ],
                ),
              );
            }

            final filteredImages =
                state.images?.where((image) {
                  final breed = image.breeds?.firstOrNull;
                  final nameMatches = (breed?.name ?? '').toLowerCase().contains(_searchQuery);
                  final originMatches = _selectedOrigin == null || breed?.origin == _selectedOrigin;
                  return nameMatches && originMatches;
                }).toList() ??
                [];

            // Group images by breed.name
            final groupedImages = <String, List<CatBreedModel>>{};
            for (var image in filteredImages) {
              final breedName = image.breeds?.firstOrNull?.name ?? 'Unknown';
              groupedImages.putIfAbsent(breedName, () => []);
              groupedImages[breedName]!.add(image);
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
                itemCount: groupedImages.keys.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= groupedImages.keys.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final breedName = groupedImages.keys.elementAt(index);
                  final images = groupedImages[breedName]!;
                  final breed = images.first.breeds?.firstOrNull;
                  print(breed?.toJson().toString());

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Card(
                      elevation: 6,
                      color: catCream,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: catOrange,
                              child: const Icon(Icons.pets, color: Colors.white),
                            ),
                            title: Text(breedName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20)),
                            subtitle: Text(breed?.origin ?? 'ต้นกำเนิดไม่ชัดเจน', style: const TextStyle(color: Color(0xFF8D5524))),

                            trailing: Chip(
                              label: Text(breed?.temperament?.split(',').first ?? '', style: const TextStyle(color: Colors.white)),
                              backgroundColor: catBrown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridColumnCount, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1),
                            itemCount: images.length,
                            itemBuilder: (context, gridIndex) {
                              final image = images[gridIndex];
                              return GestureDetector(
                                onTap: () {
                                  // ป้องกันการกดซ้ำ ๆ
                                  if (_isNavigating) return;

                                  // Debug log
                                  print('[HomePage] Tap cat: breed=${breed?.toJson()}, image=${image.url}');
                                  if (breed == null) {
                                    // แจ้งเตือนถ้า breed เป็น null
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('ไม่พบข้อมูลพันธุ์แมว'),
                                        content: const Text('ไม่สามารถแสดงรายละเอียดได้ เพราะข้อมูลพันธุ์แมวไม่สมบูรณ์'),
                                        actions: [TextButton(onPressed: () => context.pop(), child: const Text('ตกลง'))],
                                      ),
                                    );
                                    return;
                                  }

                                  // ตั้งค่า flag และ navigate
                                  _isNavigating = true;
                                  try {
                                    context.push(DetailPage.routeName, extra: {'breed': CatBreed.fromBreed(breed, image.url ?? ''), 'image': image.url}).then((_) {
                                      // รีเซ็ต flag เมื่อกลับมา
                                      if (mounted) _isNavigating = false;
                                    });
                                  } catch (e) {
                                    print('[HomePage] Navigation error: $e');
                                    _isNavigating = false;
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  color: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CachedNetworkImage(imageUrl: image.url ?? 'https://placecats.com/200/200', fit: BoxFit.cover, errorWidget: (context, url, error) => const Icon(Icons.error)),
                                        // Favorite Button
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: FavoriteButton(catId: image.id ?? '', imageUrl: image.url ?? '', breedName: breedName, breedId: breed?.id, breed: breed, size: 20),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(color: catOrange.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                child: Icon(Icons.pets, size: 16, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.read<CatBloc>().add(RefreshImages()), child: const Icon(Icons.refresh)),
      ),
    );
  }
}
