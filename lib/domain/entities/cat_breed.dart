import 'package:catencyclopedia/data/models/cat_breed_model.dart';

class CatBreed {
  final String id;
  final String url;
  final String name;
  final String? description;
  final String? origin;
  final String? temperament;
  final String? imageUrl;
  final Weight? weight;
  final String? lifeSpan;
  final int? indoor;
  final int? lap;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? catFriendly;
  final int? dogFriendly;
  final int? energyLevel;
  final int? grooming;
  final int? healthIssues;
  final int? intelligence;
  final int? sheddingLevel;
  final int? socialNeeds;
  final int? strangerFriendly;
  final int? vocalisation;
  final int? hypoallergenic;

  CatBreed({
    required this.id,
    required this.name,
    required this.url,
    this.description,
    this.origin,
    this.temperament,
    this.imageUrl,
    this.weight,
    this.lifeSpan,
    this.indoor,
    this.lap,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.catFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.grooming,
    this.healthIssues,
    this.intelligence,
    this.sheddingLevel,
    this.socialNeeds,
    this.strangerFriendly,
    this.vocalisation,
    this.hypoallergenic,
  });

  String? get weightMetric => weight?.metric ?? 'ไม่มีข้อมูลน้ำหนัก';
  String? get weightImperial => weight?.imperial ?? 'ไม่มีข้อมูลน้ำหนัก';

  // Factory method เพื่อแปลงจาก Breed model (Data Layer) เป็น CatBreed entity (Domain Layer)
  factory CatBreed.fromBreed(Breed breed, String imageUrl) {
    return CatBreed(
      id: breed.id ?? '',
      name: breed.name ?? '',
      url: imageUrl,
      description: breed.description,
      origin: breed.origin,
      temperament: breed.temperament,
      imageUrl: imageUrl,
      weight: breed.weight,
      lifeSpan: breed.lifeSpan,
      indoor: breed.indoor,
      lap: breed.lap,
      adaptability: breed.adaptability,
      affectionLevel: breed.affectionLevel,
      childFriendly: breed.childFriendly,
      catFriendly: breed.catFriendly,
      dogFriendly: breed.dogFriendly,
      energyLevel: breed.energyLevel,
      grooming: breed.grooming,
      healthIssues: breed.healthIssues,
      intelligence: breed.intelligence,
      sheddingLevel: breed.sheddingLevel,
      socialNeeds: breed.socialNeeds,
      strangerFriendly: breed.strangerFriendly,
      vocalisation: breed.vocalisation,
      hypoallergenic: breed.hypoallergenic,
    );
  }
}
