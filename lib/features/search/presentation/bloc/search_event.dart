import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

// user typed text -> filter users
final class SearchTextChanged extends SearchEvent {
  final String query;

  const SearchTextChanged({required this.query});

  @override
  List<Object> get props => [query];
}
