class CatBreed {
  final String id;
  final String name;
  final String? description;
  final String? origin;
  final String? temperament;
  final String? imageUrl;
  final String? weight;
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
}
