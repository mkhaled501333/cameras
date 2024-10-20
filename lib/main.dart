import 'package:flutter/material.dart';

// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyScreen(),
    ),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  // Create a [Player] to control playback.
  // late final player = Player();
  // late final player2 = Player();
  // Create a [VideoController] to handle video output from [Player].
  // late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    // Play a [Media] or [Playlist].
    // player.open(Playlist([
    //   Media('rtsp://admin:Admin@123@192.168.1.90:554/Streaming/Channels/101'),
    //   Media('rtsp://admin:Admin@123@192.168.1.90:554/Streaming/Channels/201'),
    //   Media('rtsp://admin:Admin@123@192.168.1.90:554/Streaming/Channels/301'),
    // ]));
    // player2.open(Playlist([
    //   Media('rtsp://admin:Admin@123@192.168.1.4:554/Streaming/Channels/101'),
    //   Media('rtsp://admin:Admin@123@192.168.1.4:554/Streaming/Channels/201'),
    //   Media('rtsp://admin:Admin@123@192.168.1.4:554/Streaming/Channels/301'),
    // ]));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          children: <Widget>[...cameras(10, "122")],
        ),
      ),
    );
  }
}

cameras(int camerasNum, String ip) {
  return List.generate(camerasNum, (i) => i + 1).map((v) {
    final e = v * 100 + 2;

    final q = Player(configuration: PlayerConfiguration());
    return FutureBuilder(
      future: q.open(Media(
          'rtsp://admin:Admin@123@192.168.1.$ip:554/Streaming/Channels/$e')),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Video(
            height: 220,
            width: 380,
            fit: BoxFit.fill,
            onEnterFullscreen: () {
              return q.open(Media(
                  'rtsp://admin:Admin@123@192.168.1.$ip:554/Streaming/Channels/${e - 1}'));
            },
            onExitFullscreen: () {
              return q.open(Media(
                  'rtsp://admin:Admin@123@192.168.1.$ip:554/Streaming/Channels/$e'));
            },
            controller: VideoController(
              q,
            ));
      },
    );
  }).toList();
}
