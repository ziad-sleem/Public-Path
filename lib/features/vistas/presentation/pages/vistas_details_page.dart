import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';

// import 'package:media_kit_video/.dart';
import 'package:social_media_app_using_firebase/features/create_video/domain/entities/video_entity.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_bloc.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_event.dart';

class VistasDetailsPage extends StatefulWidget {
  final VideoEntity video;
  const VistasDetailsPage({super.key, required this.video});

  @override
  State<VistasDetailsPage> createState() => _VistasDetailsPageState();
}

class _VistasDetailsPageState extends State<VistasDetailsPage> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();

    player = Player();
    controller = VideoController(player);

    player.open(Media(widget.video.videoUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(title: Text(widget.video.userName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // VIDEO PLAYER
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(controller: controller),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.caption,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.video.userImage),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.video.userName),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ❤️ ACTIONS (next step 👇)
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.favorite), onPressed: () {}),
        Text(widget.video.likes.length.toString()),

        const SizedBox(width: 20),

        IconButton(icon: const Icon(Icons.thumb_down), onPressed: () {}),
        Text(widget.video.disLikes.length.toString()),
      ],
    );
  }
}
