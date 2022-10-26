import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter({this.className});
  String? className;

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];

    final message =
        color!('$emoji $className - ${event.message} - ${event.stackTrace}');

    return [message];
  }
}
