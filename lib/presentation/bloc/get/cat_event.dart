abstract class CatEvent {}

class LoadImages extends CatEvent {}

class GetFact extends CatEvent {}

class RefreshImages extends CatEvent {}

class SearchBreeds extends CatEvent {
  final String query;
  SearchBreeds(this.query);
}

class LoadMoreImages extends CatEvent {}
