import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:flutter_shorts/model/post_model.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_shorts/widgets/profile_button.dart';

class DisplayShortsScreen extends StatefulWidget {
  final List<Post> posts;

  const DisplayShortsScreen({required this.posts, Key? key}) : super(key: key);

  @override
  _DisplayShortsScreenState createState() => _DisplayShortsScreenState();
}

class _DisplayShortsScreenState extends State<DisplayShortsScreen> {
  final List<Color> colors = [Colors.white, Colors.grey];
  final List<int> duration = [900, 700, 600, 800, 500];

  PageController controller = PageController(initialPage: 0);
  late Random random;
  bool showFullScreen = false;
  late VideoPlayerController fullScreenVideoController;
  ChewieController? chewieController;
  late VideoPlayerController currentVideoController;
  int currentVideoIndex = 0;
  bool isLiked = false;
  int likeCount = 0;
  bool showLikeAnimation = false;

  @override
  void initState() {
    super.initState();
    random = Random();
    currentVideoController = VideoPlayerController.network(
        widget.posts[currentVideoIndex].submission.mediaUrl);
    currentVideoController.initialize().then((_) {
      setState(() {});
      currentVideoController.play();
    });

    currentVideoController.addListener(() {
      if (!currentVideoController.value.isPlaying &&
          currentVideoController.value.position ==
              currentVideoController.value.duration) {
        // Video playback finished, go to the next video
        controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    currentVideoController.dispose();
    fullScreenVideoController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  void enterFullScreen(VideoPlayerController controller) {
    setState(() {
      showFullScreen = true;
      fullScreenVideoController = controller;
      chewieController = ChewieController(
        videoPlayerController: fullScreenVideoController,
        autoPlay: true,
        looping: true,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        allowFullScreen: false,
        showControls: false,
      );
    });
  }

  void exitFullScreen() {
    setState(() {
      showFullScreen = false;
      fullScreenVideoController.pause();
      fullScreenVideoController.dispose();
      chewieController?.dispose();
    });
  }

  void toggleVideoPlayback() {
    if (currentVideoController.value.isPlaying) {
      currentVideoController.pause();
    } else {
      currentVideoController.play();
    }
  }

  void toggleLike() {
    if (mounted) {
      setState(() {
        if (isLiked) {
          likeCount--;
          isLiked = false;
        } else {
          likeCount++;
          isLiked = true;
          showLikeAnimation = true;
          Timer(Duration(seconds: 2), () {
            setState(() {
              showLikeAnimation = false;
            });
          });
        }
      });
    }
  }
Widget buildVideoPostWidget(Post post, VideoPlayerController controller) {
  return Stack(
    children: [
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            toggleVideoPlayback();
          },
          child: VideoPlayer(currentVideoController),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileButton(
                  url: post.creator.pic,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '@${post.creator.handle}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${post.creator.name} ',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextSpan(
                            text: '#${post.submission.title}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: MiniMusicVisualizer(
                    color: Colors.white,
                    width: 4,
                    height: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      Positioned(
        bottom: 150,
        right: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                toggleLike();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 37,
                    width: 37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.5),
                      color: isLiked ? Colors.pink : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.white : Colors.white54,
                      size: 25,
                    ),
                  ),
                  if (showLikeAnimation)
                    Lottie.network(
                      "https://assets9.lottiefiles.com/packages/lf20_hqlccpsv.json",
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      animate: showLikeAnimation,
                      repeat: false,
                    ),
                ],
              ),
            ),
           
            Text(
              likeCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
             SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                // Add your logic here for the chat action
              },
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 37,
              ),
            ),
            Text(
              (post.comment.count).toString(),
              style: TextStyle(color: Colors.white),
            ),
             SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                // Add your logic here for the send action
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 37,
              ),
            ),
            Text(
              'send',
              style: TextStyle(color: Colors.white),
            ),
             SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                // Add your logic here for the reply action
              },
              child: Icon(
                Icons.reply,
                color: Colors.white,
                size: 37,
              ),
            ),
            Text(
              'reply',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              scrollDirection: Axis.vertical,
              itemCount: widget.posts.length,
              onPageChanged: (int index) {
                setState(() {
                  currentVideoIndex = index;
                  currentVideoController.pause();
                  currentVideoController.dispose();
                  currentVideoController = VideoPlayerController.network(
                      widget.posts[currentVideoIndex].submission.mediaUrl);
                  currentVideoController.initialize().then((_) {
                    setState(() {});
                    currentVideoController.play();
                  });
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return buildVideoPostWidget(
                    widget.posts[index], currentVideoController);
              },
            ),
            if (showFullScreen)
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: Chewie(
                    controller: chewieController!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
