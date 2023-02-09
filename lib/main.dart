import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zego',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final liveIDController =
      TextEditingController(text: Random().nextInt(900000 + 100000).toString());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User ID: $userID'),
            const SizedBox(height: 16),
            const Text('Please test with more than rwo devices'),
            const SizedBox(height: 20),
            TextFormField(
              controller: liveIDController,
              decoration: const InputDecoration(
                  labelText: 'Join or start a live by inputting an ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bool isHost = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LivePage(
                              liveID: liveIDController.text,
                              isHost: isHost,
                            )));
              },
              child: const Text('Start a live'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bool isHost = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LivePage(
                              liveID: liveIDController.text,
                              isHost: isHost,
                            )));
              },
              child: const Text('Join a live'),
            ),
          ],
        ),
      ),
    );
  }
}

final userID = Random().nextInt(900000 + 100000).toString();

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  LivePage({Key? key, required this.liveID, this.isHost = false})
      : super(key: key);

  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: 'user_$userID',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
