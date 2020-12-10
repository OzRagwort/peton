import 'dart:developer';

import 'package:peton/model/VideoDuration.dart';

String UploadTimeCheck(String publishedDate) {
  if (publishedDate == null)
    return '시간 전';
  var videoDateTime = DateTime.parse(publishedDate);
  var utcDateTime = DateTime.now().subtract(DateTime.now().timeZoneOffset);
  var durationTime = utcDateTime.difference(videoDateTime);
  VideoDuration videoDuration = new VideoDuration(
      durationTime.inDays ~/ 365,
      (durationTime.inDays % 365) ~/ 30,
      (durationTime.inDays % 365) - (durationTime.inDays % 365) ~/ 30,
      durationTime.inHours - durationTime.inDays * Duration.hoursPerDay,
      durationTime.inMinutes - durationTime.inHours * Duration.minutesPerHour,
      durationTime.inSeconds - durationTime.inMinutes * Duration.secondsPerMinute
  );

  if(videoDuration.beforeYear == 0) {
    if(videoDuration.beforeMonth == 0) {
      if(videoDuration.beforeDay == 0) {
        if(videoDuration.beforeHour == 0) {
          if(videoDuration.beforeMinute == 0) {
            return videoDuration.beforeSecond.toString() + ' 초 전';
          }
          return videoDuration.beforeMinute.toString() + ' 분 전';
        }
        return videoDuration.beforeHour.toString() + ' 시간 전';
      }
      return videoDuration.beforeDay.toString() + ' 일 전';
    }
    return videoDuration.beforeMonth.toString() + ' 달 전';
  }
  return videoDuration.beforeYear.toString() + ' 년 전';

}