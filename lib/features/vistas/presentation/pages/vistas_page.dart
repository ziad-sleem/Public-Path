import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/create_video/domain/entities/video_entity.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_bloc.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_state.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/widgets/vistas_app_bar.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/widgets/vistas_widget.dart';

class VistasPage extends StatefulWidget {
  const VistasPage({super.key});

  @override
  State<VistasPage> createState() => _VistasPageState();
}

class _VistasPageState extends State<VistasPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: VistasAppBar(),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading || state is VideoUploading) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (state is VideosLoaded) {
            final List<VideoEntity> videos = state.videos;
            if (videos.isEmpty) {
              return Center(
                child: AppText(
                  text:
                      "No videos found, follow more people to see more videos",
                ),
              );
            }
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final VideoEntity video = videos[index];
                return VistasWidget(video: video);
              },
            );
          } else if (state is VideoError) {
            return Center(child: AppText(text: state.message));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
