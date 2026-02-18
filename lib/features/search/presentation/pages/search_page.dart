import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(title: const MyText(text: 'Search')),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(uid: user.uid),
                            ),
                          );
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
