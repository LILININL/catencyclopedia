import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../locator.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../bloc/get/cat_bloc.dart';
import '../widgets/favorite_card.dart';
import 'detail_page.dart';
import '../../domain/entities/cat_breed.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final gridColumnCount = isTablet ? 3 : 2;

    // Cat Theme Colors
    final catOrange = const Color(0xFFFFB74D);
    final catCream = const Color(0xFFFFF3E0);
    final catBrown = const Color(0xFF8D5524);

    return BlocProvider<FavoriteBloc>(
      create: (_) => sl<FavoriteBloc>()..add(LoadFavorites()),
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: catOrange,
          scaffoldBackgroundColor: catCream,
          appBarTheme: AppBarTheme(
            backgroundColor: catOrange,
            foregroundColor: Colors.white,
            elevation: 2,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white),
                const SizedBox(width: 8),
                const Text('รายการโปรด'),
              ],
            ),
            actions: [
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  if (state.favorites.isEmpty) return const SizedBox();

                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'clear_all') {
                        _showClearAllDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'clear_all',
                        child: Row(
                          children: [
                            Icon(Icons.clear_all, color: catBrown),
                            const SizedBox(width: 8),
                            Text('ลบทั้งหมด', style: TextStyle(color: catBrown)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: catOrange),
                      const SizedBox(height: 16),
                      Text('กำลังโหลดรายการโปรด...', style: TextStyle(color: catBrown, fontSize: 16)),
                    ],
                  ),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: catBrown, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'เกิดข้อผิดพลาด',
                        style: TextStyle(color: catBrown, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: TextStyle(color: catBrown),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.read<FavoriteBloc>().add(LoadFavorites()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('ลองใหม่'),
                        style: ElevatedButton.styleFrom(backgroundColor: catOrange, foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                );
              }

              if (state.favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, color: catBrown, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'ยังไม่มีรายการโปรด',
                        style: TextStyle(color: catBrown, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เพิ่มแมวที่คุณชื่นชอบได้จากหน้าหลัก',
                        style: TextStyle(color: catBrown, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.pets),
                        label: const Text('เลือกแมวโปรด'),
                        style: ElevatedButton.styleFrom(backgroundColor: catOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: catOrange,
                onRefresh: () async {
                  context.read<FavoriteBloc>().add(LoadFavorites());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridColumnCount, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = state.favorites[index];
                      return FavoriteCard(
                        favorite: favorite,
                        onTap: () => _navigateToDetail(context, favorite),
                        onRemove: () => _showRemoveDialog(context, favorite),
                        catOrange: catOrange,
                        catCream: catCream,
                        catBrown: catBrown,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, favorite) {
    // Convert FavoriteCat to CatBreed for DetailPage
    final catBreed = CatBreed(id: favorite.breedId ?? favorite.id, name: favorite.breedName, url: favorite.imageUrl, imageUrl: favorite.imageUrl);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<CatBloc>.value(
          value: sl<CatBloc>(),
          child: DetailPage(breed: catBreed, image: favorite.imageUrl),
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, favorite) {
    final catBrown = const Color(0xFF8D5524);
    final catOrange = const Color(0xFFFFB74D);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: catBrown),
            const SizedBox(width: 8),
            const Text('ลบจากรายการโปรด'),
          ],
        ),
        content: Text('คุณต้องการลบ "${favorite.breedName}" จากรายการโปรดหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: catBrown)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<FavoriteBloc>().add(RemoveFromFavorites(favorite.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: catOrange, foregroundColor: Colors.white),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final catBrown = const Color(0xFF8D5524);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: catBrown),
            const SizedBox(width: 8),
            const Text('ลบรายการโปรดทั้งหมด'),
          ],
        ),
        content: const Text('คุณต้องการลบรายการโปรดทั้งหมดหรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: catBrown)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<FavoriteBloc>().add(ClearAllFavorites());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('ลบทั้งหมด'),
          ),
        ],
      ),
    );
  }
}
