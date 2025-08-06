// import 'package:catencyclopedia/data/models/cat_breed_model.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:catencyclopedia/data/models/cat_image_model.dart';
// import 'package:catencyclopedia/domain/repositories/cat_repository.dart';
// import 'package:catencyclopedia/domain/usecases/get_cat_images.dart';
// import 'package:dartz/dartz.dart';

// import 'get_cat_images_test.mocks.dart';

// @GenerateMocks([CatRepository])
// void main() {
//   late GetCatImages useCase;
//   late MockCatRepository mockRepository;

//   setUp(() {
//     mockRepository = MockCatRepository();
//     useCase = GetCatImages(mockRepository);
//   });

//   final tImages = [
//     CatImageModel(
//       id: 'test',
//       url: 'https://test.jpg',
//       breeds: [CatBreedModel(id: 'beng', name: 'Bengal')],
//     ),
//   ];

//   test('should get cat images from repository', () async {
//     when(mockRepository.getCatImages()).thenAnswer((_) async => Right(tImages));
//     final result = await useCase();
//     expect(result, Right(tImages));
//     verify(mockRepository.getCatImages());
//     verifyNoMoreInteractions(mockRepository);
//   });
// }
