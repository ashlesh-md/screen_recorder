import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

import '../screens/video_edit/crop_page.dart';

Widget coverSelection(
    {required double height, required VideoEditorController controller}) {
  return SingleChildScrollView(
    child: Center(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: CoverSelection(
          controller: controller,
          size: height + 10,
          quantity: 8,
          selectedCoverBuilder: (cover, size) {
            return Stack(
              alignment: Alignment.center,
              children: [
                cover,
                Icon(
                  Icons.check_circle,
                  color: const CoverSelectionStyle().selectedBorderColor,
                )
              ],
            );
          },
        ),
      ),
    ),
  );
}

String formatter(Duration duration) => [
      duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
      duration.inSeconds.remainder(60).toString().padLeft(2, '0')
    ].join(":");

List<Widget> trimSlider(
    {required VideoEditorController controller,
    required double height,
    required double width}) {
  return [
    AnimatedBuilder(
      animation: Listenable.merge([
        controller,
        controller.video,
      ]),
      builder: (_, __) {
        final int duration = controller.videoDuration.inSeconds;
        final double pos = controller.trimPosition * duration;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: height / 4),
          child: Row(children: [
            Text(formatter(Duration(seconds: pos.toInt()))),
            const Expanded(child: SizedBox()),
            AnimatedOpacity(
              opacity: controller.isTrimming ? 1 : 0,
              duration: kThemeAnimationDuration,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(formatter(controller.startTrim)),
                const SizedBox(width: 10),
                Text(formatter(controller.endTrim)),
              ]),
            ),
          ]),
        );
      },
    ),
    Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: height / 4),
      child: TrimSlider(
        controller: controller,
        height: height,
        horizontalMargin: height / 4,
        child: TrimTimeline(
          controller: controller,
          padding: const EdgeInsets.only(top: 10),
        ),
      ),
    )
  ];
}

Widget topNavBar(
    {required height,
    required BuildContext context,
    required VideoEditorController controller,
    required Function()? exportCover,
    required Function()? exportVideo}) {
  return SafeArea(
    child: SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Leave editor',
            ),
          ),
          const VerticalDivider(endIndent: 22, indent: 22),
          Expanded(
            child: IconButton(
              onPressed: () => controller.rotate90Degrees(RotateDirection.left),
              icon: const Icon(Icons.rotate_left),
              tooltip: 'Rotate unclockwise',
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () =>
                  controller.rotate90Degrees(RotateDirection.right),
              icon: const Icon(Icons.rotate_right),
              tooltip: 'Rotate clockwise',
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => CropPage(controller: controller),
                ),
              ),
              icon: const Icon(Icons.crop),
              tooltip: 'Open crop screen',
            ),
          ),
          const VerticalDivider(endIndent: 22, indent: 22),
          Expanded(
            child: PopupMenuButton(
              tooltip: 'Open export menu',
              icon: const Icon(Icons.save),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: exportCover,
                  child: const Text('Export cover'),
                ),
                PopupMenuItem(
                  onTap: exportVideo,
                  child: const Text('Export video'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
