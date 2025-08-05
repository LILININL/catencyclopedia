import 'package:flutter_test/flutter_test.dart';
import 'package:catencyclopedia/data/models/cat_image_model.dart';

void main() {
  final tJson = {
    'id': 'iWyIaja-G',
    'url': 'https://cdn2.thecatapi.com/images/iWyIaja-G.jpg',
    'width': 1080,
    'height': 769,
    'breeds': [
      {
        'id': 'beng',
        'name': 'Bengal',
        'description': 'Bengals are a lot of fun...',
        'origin': 'United States',
        'temperament': 'Alert, Agile, Energetic',
        'reference_image_id': 'O3btzLlsO',
        'weight': {'imperial': '6 - 12', 'metric': '3 - 7'},
        'life_span': '12 - 15',
        'indoor': 0,
        'lap': 0,
        'adaptability': 5,
        'affection_level': 5,
        'child_friendly': 4,
        'cat_friendly': 4,
        'dog_friendly': 5,
        'energy_level': 5,
        'grooming': 1,
        'health_issues': 3,
        'intelligence': 5,
        'shedding_level': 3,
        'social_needs': 5,
        'stranger_friendly': 3,
        'vocalisation': 5,
        'hypoallergenic': 1,
      },
    ],
  };

  test('should parse JSON to CatImageModel correctly', () {
    final model = CatImageModel.fromJson(tJson);
    expect(model.id, 'iWyIaja-G');
    expect(model.url, 'https://cdn2.thecatapi.com/images/iWyIaja-G.jpg');
    expect(model.breeds?.first.name, 'Bengal');
    expect(model.breeds?.first.weight?.toString(), '3 - 7');
  });

  test('should handle missing fields with defaults', () {
    final emptyJson = {'id': 'test'};
    final model = CatImageModel.fromJson(emptyJson);
    expect(model.url, null);
    expect(model.breeds, null);
  });
}
