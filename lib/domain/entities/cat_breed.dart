import 'package:equatable/equatable.dart';

class CatBreed extends Equatable {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String temperament;
  final String imageUrl;

  const CatBreed({required this.id, required this.name, required this.description, required this.origin, required this.temperament, required this.imageUrl});

  @override
  List<Object> get props => [id, name];
}
