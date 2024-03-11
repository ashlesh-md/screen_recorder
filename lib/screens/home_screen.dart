import 'package:flutter/material.dart';

import '../models/recored_video_info.dart';
import 'tabs/record_video_tab.dart';
import 'tabs/recorded_video_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RecordedVideoInfo> recordedVideosList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Screen Recorder',
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Record Video'),
                Tab(text: 'Recorded Videos'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RecordVideoTab(onVideoRecorded: (RecordedVideoInfo info) {
                    setState(() {
                      recordedVideosList.add(info);
                    });
                  }),
                  RecordedVideosTab(recordedVideosList: recordedVideosList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
