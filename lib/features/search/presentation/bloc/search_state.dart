import 'package:equatable/equatable.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<ProfileUser> results;

  const SearchLoaded({required this.results});

  @override
  List<Object> get props => [results];
}

final class SearchError extends SearchState {
  final String errorMessage;

  const SearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
