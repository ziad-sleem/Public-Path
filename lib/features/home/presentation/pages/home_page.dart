import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/my_home_app_bar.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_widget.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on restart
  @override
  void initState() {
    super.initState();
    
    // fetch all the posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  // delete post
  void deletePost(String postId) {
    postCubit.deletePost(postId: postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHomeAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [],
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else if (state is PostLoaded) {
              final allPosts = state.posts;

              if (allPosts.isEmpty) {
                return Center(
                  child: MyText(
                    text:
                        '📍No posts availabel, follow more people to see more posts📍',
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allPosts.length,
                      itemBuilder: (context, index) {
                        return PostWidget(post: allPosts[index]);
                      },
                    ),
                  ],
                ),
              );
            } else if (state is PostError) {
              return Center(child: MyText(text: state.errorMessage));
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
