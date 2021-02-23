
String ChannelSubscriberCountCheck(int subscriberCount) {
  String value = '구독자 ';

  // 억 이상
  if (subscriberCount >= 100000000) {
    value += (subscriberCount / 100000000).toString();
    value += '억명';

  // 만 이상
  } else if (subscriberCount >= 10000) {
    value = (subscriberCount / 10000).toString();
    value += '만명';

    // 만 미만
  } else if (subscriberCount == 0) {
    return '';
    // 만 미만
  } else {
    value = subscriberCount.toString();
    value += '명';
  }

  return value;
}
