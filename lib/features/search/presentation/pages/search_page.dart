import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/other_user_profile_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/widgets/search_app_bar.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/widgets/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(SearchTextChanged(query: query));
    });
  }

  @override
  Widget build(BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
            backgroundColor: colorScheme.surface,

      appBar: SearchAppBar(),
      body: Column(
        children: [
          // Search input
          SearchTextField(
            searchController: _searchController,
            onChanged: _onSearchChanged,
          ),

          // Results
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchLoaded) {
                  if (state.results.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final user = state.results[index];
                      final currentUser = context.read<AuthCubit>().currentUser;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          child: ClipOval(
                            child:
                                user.profileImage != null &&
                                    user.profileImage!.isNotEmpty
                                ? (user.profileImage!.startsWith('http')
                                      ? Image.network(
                                          user.profileImage!,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child:
                                                      CircularProgressIndicator.adaptive(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.person),
                                        )
                                      : Image.memory(
                                          base64Decode(user.profileImage!),
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.person),
                                        ))
                                : const Icon(Icons.person),
                          ),
                        ),
                        title: Text(user.username),
                        subtitle: Text(
                          user.bio != null && user.bio!.isNotEmpty
                              ? user.bio!
                              : user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          if (currentUser?.uid == user.uid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(uid: user.uid),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => getIt<ProfileCubit>()
                                        ..fetchUserProfile(user.uid),
                                    ),
                                    BlocProvider(
                                      create: (context) => getIt<HomeCubit>()
                                        ..doEvent(
                                          FetchAllPostByUserIdEvent(
                                            userId: user.uid,
                                          ),
                                        ),
                                    ),
                                  ],
                                  child: OtherUserProfilePage(uid: user.uid),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }

                if (state is SearchError) {
                  return Center(child: Text(state.errorMessage));
                }

                // initial state or anything else
                return const Center(child: Text('Search'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
