
import 'package:android_intent/android_intent.dart';

class LaunchYoutube {

  static openYoutube(String videoId) {
    final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://www.youtube.com/watch?v=' + videoId),
        package: 'com.google.android.youtube');
    intent.launch();
  }

}