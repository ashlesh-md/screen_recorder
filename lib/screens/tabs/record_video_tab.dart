import 'dart:async';

import 'package:device_screen_recorder/device_screen_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/recored_video_info.dart';

class RecordVideoTab extends StatefulWidget {
  final Function(RecordedVideoInfo) onVideoRecorded;

  const RecordVideoTab({required this.onVideoRecorded});

  @override
  _RecordVideoTabState createState() => _RecordVideoTabState();
}

class _RecordVideoTabState extends State<RecordVideoTab> {
  bool recording = false;
  String path = '';
  String thumbnailPath = '';
  VideoPlayerController? _controller;
  int maxRecordingTime = 60;
  int timerSeconds = 0;
  late Timer timer;

  String selectedResolution = 'HD';
  String selectedFrameRate = '30';
  String selectedBitrate = '4000000';
  String selectedOrientation = 'Portrait Up';

  final List<String> resolutions = ['HD', 'Full HD', '4K'];
  final List<String> frameRates = ['24', '30', '60'];
  final List<String> bitrates = ['2000000', '4000000', '8000000'];

  bool isAudioEnabled = true;

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _controller = VideoPlayerController.network(videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _generateThumbnail(String videoPath) async {
    thumbnailPath = (await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 50,
    ))!;
  }

  Widget _buildSelectionButton(String label, VoidCallback onPressed) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(
    List<String> options,
    String title,
    Function(String) onSelect,
  ) async {
    String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  Navigator.pop(context, option);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (result != null) {
      onSelect(result);
    }
  }

  Future<void> _showOrientationDialog() async {
    DeviceOrientation? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Orientation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Portrait Up'),
                onTap: () {
                  Navigator.pop(context, DeviceOrientation.portraitUp);
                },
              ),
              ListTile(
                title: const Text('Portrait Down'),
                onTap: () {
                  Navigator.pop(context, DeviceOrientation.portraitDown);
                },
              ),
              ListTile(
                title: const Text('Landscape Left'),
                onTap: () {
                  Navigator.pop(context, DeviceOrientation.landscapeLeft);
                },
              ),
              ListTile(
                title: const Text('Landscape Right'),
                onTap: () {
                  Navigator.pop(context, DeviceOrientation.landscapeRight);
                },
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        switch (result) {
          case DeviceOrientation.portraitUp:
            selectedOrientation = 'Portrait Up';
            break;

          case DeviceOrientation.portraitDown:
            selectedOrientation = 'Portrait Down';
            break;

          case DeviceOrientation.landscapeRight:
            selectedOrientation = 'Landscape Right';
            break;

          case DeviceOrientation.landscapeLeft:
            selectedOrientation = 'Landscape Left';
            break;
          default:
            selectedOrientation = 'Portrait Up';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSelectionButton(
            'Resolution: $selectedResolution',
            () => _showSelectionDialog(resolutions, 'Select Resolution',
                (value) => setState(() => selectedResolution = value)),
          ),
          _buildSelectionButton(
            'Frame Rate: $selectedFrameRate fps',
            () => _showSelectionDialog(frameRates, 'Select Frame Rate',
                (value) => setState(() => selectedFrameRate = value)),
          ),
          _buildSelectionButton(
            'Bitrate: $selectedBitrate bps',
            () => _showSelectionDialog(bitrates, 'Select Bitrate',
                (value) => setState(() => selectedBitrate = value)),
          ),
          _buildSelectionButton(
            'Orientation: ${selectedOrientation.toString()}',
            () => _showOrientationDialog(),
          ),
          const SizedBox(height: 20), // Increase vertical padding

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Audio:',
                  style: TextStyle(fontSize: 18, color: Colors.indigo)),
              Switch(
                value: isAudioEnabled,
                onChanged: (value) {
                  setState(() {
                    isAudioEnabled = value;
                  });
                },
                activeColor: Colors.indigo,
              ),
            ],
          ),

          const SizedBox(height: 20), // Increase vertical padding

          recording
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: LinearProgressIndicator(
                        value: timerSeconds / maxRecordingTime,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        await _stopRecording();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                      ),
                      child: const Text('End Video'),
                    ),
                  ],
                )
              : OutlinedButton(
                  onPressed: () async {
                    await _toggleRecording();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                  ),
                  child: Text(recording ? 'Stop Recording' : 'Start Recording'),
                ),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (recording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    var status = await DeviceScreenRecorder.startRecordScreen();

    if (status != null && status) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          if (timerSeconds < maxRecordingTime) {
            timerSeconds++;
          } else {
            _stopRecording();
          }
        });
      });

      setState(() {
        recording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    var file = await DeviceScreenRecorder.stopRecordScreen();
    if (file != null) {
      setState(() async {
        path = file;
        recording = false;
        await _generateThumbnail(path);
        await _initializeVideoPlayer(path);
        timer.cancel();
        timerSeconds = 0;
        widget.onVideoRecorded(
          RecordedVideoInfo(
            videoPath: path,
            thumbnailPath: thumbnailPath,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }
}
