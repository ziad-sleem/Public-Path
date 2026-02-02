part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostUpLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded({required this.posts});
}

final class PostError extends PostState {
  final String errorMessage;

  const PostError({required this.errorMessage});
}
