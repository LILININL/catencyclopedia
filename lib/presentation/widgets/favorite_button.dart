import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../../domain/entities/favorite_cat.dart';

class FavoriteButton extends StatelessWidget {
  final String catId;
  final String imageUrl;
  final String breedName;
  final String? breedId;
  final Color? color;
  final double size;

  const FavoriteButton({super.key, required this.catId, required this.imageUrl, required this.breedName, this.breedId, this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final catOrange = color ?? const Color(0xFFFFB74D);

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(catId);

        return GestureDetector(
          onTap: () => _toggleFavorite(context, isFavorite),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : catOrange, size: size),
          ),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, bool currentIsFavorite) {
    final favoriteBloc = context.read<FavoriteBloc>();

    if (currentIsFavorite) {
      // ลบจากรายการโปรด
      favoriteBloc.add(RemoveFromFavorites(catId));

      // แสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('ลบ "$breedName" จากรายการโปรดแล้ว'),
              ),
            ],
          ),
          backgroundColor: Colors.grey[600],
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'เลิกทำ',
            textColor: Colors.white,
            onPressed: () {
              // เพิ่มกลับเข้าไป
              _addToFavorites(context);
            },
          ),
        ),
      );
    } else {
      // เพิ่มเข้ารายการโปรด
      _addToFavorites(context);

      // แสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('เพิ่ม "$breedName" เข้ารายการโปรดแล้ว'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'ดู',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to favorites page
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ),
      );
    }
  }

  void _addToFavorites(BuildContext context) {
    final favoriteCat = FavoriteCat(id: catId, imageUrl: imageUrl, breedName: breedName, breedId: breedId, addedAt: DateTime.now());

    context.read<FavoriteBloc>().add(AddToFavorites(favoriteCat));
  }
}

/// Floating Favorite Button สำหรับใช้ใน DetailPage
class FavoriteFab extends StatelessWidget {
  final String catId;
  final String imageUrl;
  final String breedName;
  final String? breedId;

  const FavoriteFab({super.key, required this.catId, required this.imageUrl, required this.breedName, this.breedId});

  @override
  Widget build(BuildContext context) {
    final catOrange = const Color(0xFFFFB74D);

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(catId);

        return FloatingActionButton(
          onPressed: () => _toggleFavorite(context, isFavorite),
          backgroundColor: isFavorite ? Colors.red : catOrange,
          foregroundColor: Colors.white,
          child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, size: 28),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, bool currentIsFavorite) {
    final favoriteBloc = context.read<FavoriteBloc>();

    if (currentIsFavorite) {
      favoriteBloc.add(RemoveFromFavorites(catId));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ลบ "$breedName" จากรายการโปรดแล้ว'), backgroundColor: Colors.grey[600], duration: const Duration(seconds: 2)));
    } else {
      final favoriteCat = FavoriteCat(id: catId, imageUrl: imageUrl, breedName: breedName, breedId: breedId, addedAt: DateTime.now());

      favoriteBloc.add(AddToFavorites(favoriteCat));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เพิ่ม "$breedName" เข้ารายการโปรดแล้ว'), backgroundColor: Colors.red, duration: const Duration(seconds: 2)));
    }
  }
}
