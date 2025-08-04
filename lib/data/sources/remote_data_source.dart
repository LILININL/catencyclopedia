import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat_breed_model.dart';

class RemoteDataSource {
  final http.Client client;
  RemoteDataSource(this.client);

  Future<List<CatBreedModel>> getCatBreeds() async {
    final response = await client.get(Uri.parse('https://api.thecatapi.com/v1/breeds'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => CatBreedModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<String> getRandomFact() async {
    final response = await client.get(Uri.parse('https://catfact.ninja/fact'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['fact'];
    } else {
      throw Exception('Failed to load fact');
    }
  }
}
