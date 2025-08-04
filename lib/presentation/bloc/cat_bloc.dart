import 'package:bloc/bloc.dart';
import '../../domain/usecases/get_cat_breeds.dart';
import '../../domain/usecases/get_random_fact.dart';
import 'cat_event.dart';
import 'cat_state.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  final GetCatBreeds getBreeds;
  final GetRandomFact getFact;

  CatBloc({required this.getBreeds, required this.getFact}) : super(CatState()) {
    on<LoadBreeds>(_onLoadBreeds); // Register handler สำหรับ LoadBreeds
    on<GetFact>(_onGetFact); // Register สำหรับ GetFact
  }

  Future<void> _onLoadBreeds(LoadBreeds event, Emitter<CatState> emit) async {
    emit(CatState(isLoading: true)); // Loading
    try {
      final breeds = await getBreeds();
      emit(CatState(breeds: breeds)); // Success
    } catch (e) {
      emit(CatState(error: e.toString())); // Error
    }
  }

  Future<void> _onGetFact(GetFact event, Emitter<CatState> emit) async {
    emit(CatState(isLoading: true));
    try {
      final fact = await getFact();
      emit(CatState(fact: fact));
    } catch (e) {
      emit(CatState(error: e.toString()));
    }
  }
}
