import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_widgets/my_home_app_bar.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch posts when the page is initialy loaded
    _fetchPosts();
  }

  void _fetchPosts() {
    context.read<HomeCubit>().doEvent(FetchAllPostEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MyHomeAppBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is HomeLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => _fetchPosts(),
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const Center(
                      child: AppText(
                        text:
                            '📍No posts available, follow more people to see more posts📍',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _fetchPosts(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: allPosts[index]);
                },
              ),
            );
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(text: state.errorMessage, color: colorScheme.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            // HomeInitial: Trigger fetch if for some reason it wasn't triggered
            WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPosts());
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
