import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../widgets/favorite_card.dart';
import 'detail_page.dart';
import 'home_page.dart';

class FavoritesPage extends StatelessWidget {
  static const String routeName = '/favorites';
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final gridColumnCount = isTablet ? 3 : 2;

    // Cat Theme Colors
    final catOrange = const Color(0xFFFFB74D);
    final catCream = const Color(0xFFFFF3E0);
    final catBrown = const Color(0xFF8D5524);

    return Theme(
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go(HomePage.routeName),
          ),
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
                      style: TextStyle(color: catBrown, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoriteBloc>().add(LoadFavorites());
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: catOrange),
                      child: const Text('ลองใหม่', style: TextStyle(color: Colors.white)),
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
                      'กดไอคอน ❤️ เพื่อเพิ่มแมวลงรายการโปรด',
                      style: TextStyle(color: catBrown, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.go(HomePage.routeName),
                      style: ElevatedButton.styleFrom(backgroundColor: catOrange),
                      child: const Text('เลือกแมว', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumnCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8, // Adjust for card content
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final favorite = state.favorites[index];
                  return GestureDetector(
                    onTap: () {
                      final favorite = state.favorites[index];
                      final catBreed = favorite.toCatBreed();
                      context.push(DetailPage.routeName, extra: {'breed': catBreed, 'image': favorite.imageUrl});
                    },
                    child: FavoriteCard(
                      favorite: favorite,
                      catOrange: catOrange,
                      catCream: catCream,
                      catBrown: catBrown,
                      onTap: () {
                        final catBreed = favorite.toCatBreed();
                        context.push(DetailPage.routeName, extra: {'breed': catBreed, 'image': favorite.imageUrl});
                      },
                      onRemove: () {
                        context.read<FavoriteBloc>().add(RemoveFromFavorites(favorite.id));
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final catOrange = const Color(0xFFFFB74D);
    final catBrown = const Color(0xFF8D5524);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: catOrange),
            const SizedBox(width: 8),
            const Text('ยืนยันการลบ'),
          ],
        ),
        content: const Text('คุณต้องการลบรายการโปรดทั้งหมดใช่หรือไม่?\n\nการกระทำนี้ไม่สามารถยกเลิกได้'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('ยกเลิก', style: TextStyle(color: catBrown)),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
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
