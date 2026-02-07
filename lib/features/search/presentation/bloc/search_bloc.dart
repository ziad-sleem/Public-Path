import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/search/domain/repos/search_repo.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_event.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_state.dart';

export 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_event.dart';
export 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo searchRepo;

  SearchBloc({required this.searchRepo}) : super(SearchInitial()) {
    on<SearchTextChanged>(_onSearch);
  }

  /// handle search query
  Future<void> _onSearch(
    SearchTextChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(event.query);
      emit(SearchLoaded(results: users));
    } catch (e) {
      emit(SearchError(errorMessage: e.toString()));
    }
  }
}
