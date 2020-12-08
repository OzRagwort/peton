import 'package:intl/intl.dart';

String ViewCountCheck(int viewCount) {
  return new NumberFormat('###,###,###,###').format(viewCount);
}
