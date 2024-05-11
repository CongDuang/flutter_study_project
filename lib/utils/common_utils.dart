import 'dart:io';

import 'package:just_audio/just_audio.dart';

class CommonUtils {
  CommonUtils._();

  static bool isUrlValid(String? url) {
    if (null == url || url.isEmpty) {
      return false;
    }
    return url.startsWith("http://") || url.startsWith("https://");
  }

  static Future<Duration> getAudioDuration(File file) async {
    final player = AudioPlayer();
    var duration = await player.setUrl(file.path);
    return duration ?? const Duration(seconds: 0);
  }
}
