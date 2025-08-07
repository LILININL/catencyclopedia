import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/date_utils.dart';

/// A card widget for displaying favorite cat information
class FavoriteCard extends StatelessWidget {
  final dynamic favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final Color catOrange;
  final Color catCream;
  final Color catBrown;

  const FavoriteCard({
    super.key,
    required this.favorite,
    required this.onTap,
    required this.onRemove,
    required this.catOrange,
    required this.catCream,
    required this.catBrown,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: favorite.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: catCream,
                        child: Center(
                          child: CircularProgressIndicator(color: catOrange),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: catCream,
                        child: Center(
                          child: Icon(Icons.pets, color: catBrown, size: 32),
                        ),
                      ),
                    ),
                  ),
                  // Remove Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _showRemoveDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      favorite.breedName,
                      style: TextStyle(
                        color: catBrown,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    // แสดงข้อมูลเพิ่มเติมถ้ามี (แค่ 1 อย่าง)
                    if (favorite.origin != null) ...[
                      Row(
                        children: [
                          Icon(Icons.location_on, color: catOrange, size: 10),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              favorite.origin!,
                              style: TextStyle(
                                color: catBrown.withOpacity(0.8),
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ] else if (favorite.temperament != null) ...[
                      Row(
                        children: [
                          Icon(Icons.pets, color: catOrange, size: 10),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              favorite.temperament!.split(',').first.trim(),
                              style: TextStyle(
                                color: catBrown.withOpacity(0.8),
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 2),
                    
                    // แสดงสถานะข้อมูล
                    Row(
                      children: [
                        Icon(
                          favorite.isFullyLoaded 
                            ? Icons.cloud_done 
                            : Icons.cloud_download,
                          color: favorite.isFullyLoaded 
                            ? Colors.green 
                            : catOrange,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            favorite.isFullyLoaded 
                              ? 'ข้อมูลครบถ้วน' 
                              : 'ข้อมูลพื้นฐาน',
                            style: TextStyle(
                              color: favorite.isFullyLoaded 
                                ? Colors.green 
                                : catOrange,
                              fontSize: 9,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    Row(
                      children: [
                        Icon(Icons.schedule, color: catOrange, size: 10),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            AppDateUtils.formatRelativeTime(favorite.addedAt),
                            style: TextStyle(
                              color: catBrown.withOpacity(0.7),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context) {
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
        content: Text('คุณต้องการลบ "${favorite.breedName}" จากรายการโปรดใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: catBrown)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onRemove();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }
}
