import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayFromUrl extends StatefulWidget {
  var url;
  dynamic d;
  VideoPlayFromUrl({Key? key, required this.url, required this.d}) : super(key: key);

  @override
  State<VideoPlayFromUrl> createState() => _VideoPlayFromUrlState();
}

class _VideoPlayFromUrlState extends State<VideoPlayFromUrl> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;
  var loading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor, // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("${widget.d["title"]}"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : chewieController != null && chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: chewieController,
                )
              : CircularProgressIndicator(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void getData() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      looping: true,
      showOptions: true,
      autoPlay: true,
      allowFullScreen: true,
      allowMuting: true,
    );
    setState(() {
      loading = false;
    });
  }
}
