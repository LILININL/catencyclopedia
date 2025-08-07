import 'package:catencyclopedia/presentation/bloc/get/cat_state.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  final CatState state;
  final Function(String?) onSelected;

  const FilterDialog({super.key, required this.state, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final uniqueOrigins = state.images?.map((image) => image.breeds?.firstOrNull?.origin ?? 'Unknown').toSet().toList() ?? [];

    return AlertDialog(
      title: const Text('กรองตามต้นกำเนิด'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('ทั้งหมด'),
              onTap: () {
                onSelected(null);
                Navigator.pop(context);
              },
            ),
            ...uniqueOrigins.map(
              (origin) => ListTile(
                title: Text(origin),
                onTap: () {
                  onSelected(origin);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
