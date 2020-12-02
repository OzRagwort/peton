// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Playback rate or speed for the video.
///
/// Find more about it [here](https://developers.google.com/youtube/iframe_api_reference#getPlaybackRate).
class PlaybackQuality {
  /// Sets playback quality to highres
  static const String highres = "highres";

  /// Sets playback quality to hd1080
  static const String hd1080 = "hd1080";

  /// Sets playback quality to hd720
  static const String hd720 = "hd720";

  /// Sets playback quality to large
  static const String large = "large";

  /// Sets playback quality to medium
  static const String medium = "medium";

  /// Sets playback quality to small
  static const String small = "small";

  /// All
  static const List<String> all = [
    highres,
    hd1080,
    hd720,
    large,
    medium,
    small,
  ];
}
