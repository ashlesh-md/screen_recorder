# Screen Recorder App

A Flutter project for creating a screen recorder application.

## Summary

The Screen Recorder Flutter app provides users with a comprehensive solution for capturing their device screens seamlessly. With features such as easy screen recording, video editing capabilities, and the ability to share recordings, this app aims to simplify the process of creating and managing screen recordings on Flutter-supported devices.

## Getting Started

Welcome to the Screen Recorder Flutter project! This application serves as a starting point for developing a Flutter-based screen recording application.

## Features

- Record your device screen with ease.
- View and edit recorded videos.
- Share your recordings with others.

## Dependencies

This project relies on the following Flutter packages and plugins:

- **path_provider:** For handling file paths.
- **share_it:** For sharing recorded videos.
- **video_player:** For playing videos within the app.
- **device_screen_recorder:** For recording the device screen.
- **video_thumbnail:** For generating video thumbnails.
- **fraction:** A utility for performing fraction-based calculations.
- **video_editor:** For video editing capabilities.
- **image_gallery_saver:** For saving images to the device's gallery.
- **ffmpeg_kit_flutter_min:** Flutter bindings for FFmpeg.

## Getting Started

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/ashlesh-md/screen_recorder/tree/development

   flutter pub get

   flutter run
   ```

## Challenges

The development process encountered challenges, particularly with screen recording packages. Many packages were not effective and did not work as expected. The search for the correct package consumed approximately 36 hours of development time. This should be considered
when evaluating the development timeline.

## Future Work

If a more effective screen recording package becomes available, it can be easily integrated, as much of the code is designed to be reusable. Continuous improvement and exploration of new packages are part of the future development plan.
