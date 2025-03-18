import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/controller/profile_controller.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Video')),
      body: Center(
        child: Obx(() {
          if (!profileController.isVideoInitialized.value) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Loading video...")
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: profileController.videoController.value.aspectRatio,
                child: VideoPlayer(profileController.videoController),
              ),
              const SizedBox(height: 0),
              ElevatedButton.icon(
                onPressed: () {
                  profileController.playPauseVideo();
                },
                icon: Obx(() => Icon(
                  profileController.isVideoPlaying.value ? Icons.pause : Icons.play_arrow,
                )),
                label: Obx(() => Text(
                  profileController.isVideoPlaying.value ? "Pause Video" : "Play Video",
                )),
              ),
            ],
          );
        }),
      ),
    );
  }
}
