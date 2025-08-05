import 'dart:io';

import 'package:catencyclopedia/locator.dart';
import 'package:catencyclopedia/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catencyclopedia/presentation/bloc/cat_bloc.dart';
import 'package:catencyclopedia/presentation/bloc/cat_state.dart';
import 'package:catencyclopedia/data/models/cat_image_model.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'test_helper.mocks.dart';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(path.join(tempDir.path, 'hive_test'));
    await initLocator();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('HomePage shows loading indicator when state is loading', (WidgetTester tester) async {
    final mockBloc = MockCatBloc();
    when(mockBloc.state).thenReturn(CatState(isLoading: true));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CatBloc>.value(value: mockBloc, child: const HomePage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomePage shows ListView with breeds when images loaded', (WidgetTester tester) async {
    final mockBloc = MockCatBloc();
    final testImages = [
      CatImageModel(
        id: 'test',
        url: 'https://test.jpg',
        breeds: [CatBreedModel(id: 'beng', name: 'Bengal')],
      ),
    ];
    when(mockBloc.state).thenReturn(CatState(images: testImages));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CatBloc>.value(value: mockBloc, child: const HomePage()),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Bengal'), findsOneWidget); // OK เพราะ UI ใช้ breed.name
  });
}
