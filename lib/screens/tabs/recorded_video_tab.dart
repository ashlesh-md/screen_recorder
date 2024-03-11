import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screen_recorder/screens/custom_video_editor.dart';
import 'package:share_it/share_it.dart';

import '../../models/recored_video_info.dart';
import '../video_player_screen.dart';

class RecordedVideosTab extends StatelessWidget {
  final List<RecordedVideoInfo> recordedVideosList;

  const RecordedVideosTab({required this.recordedVideosList});

  Future<void> _editVideo(
    BuildContext context,
    RecordedVideoInfo videoInfo,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoEditor(file: File(videoInfo.videoPath)),
      ),
    );
  }

  Future<void> _viewVideo(
    BuildContext context,
    RecordedVideoInfo videoInfo,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoInfo: videoInfo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: recordedVideosList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _viewVideo(context, recordedVideosList[index]);
          },
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildCoverImage(recordedVideosList[index].thumbnailPath),
                _buildOptions(context, recordedVideosList[index]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoverImage(String thumbnailPath) {
    return Image.file(
      File(thumbnailPath),
      width: double.infinity,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  Future<void> _shareVideo(
      BuildContext context, RecordedVideoInfo videoInfo) async {
    try {
      await ShareIt.file(
        path: videoInfo.videoPath,
        type: ShareItFileType.video,
      );
    } catch (e) {
      print('Error sharing video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sharing video'),
        ),
      );
    }
  }

  Widget _buildOptions(BuildContext context, RecordedVideoInfo videoInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () {
            _editVideo(context, videoInfo);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.indigo,
          ),
          child: const Text(
            'Edit Video',
            style: TextStyle(fontSize: 16),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            _viewVideo(context, videoInfo);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.indigo,
          ),
          child: const Text(
            'View Video',
            style: TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: () {
            _shareVideo(context, videoInfo);
          },
          icon: const Icon(
            Icons.share,
            size: 25,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }
}
