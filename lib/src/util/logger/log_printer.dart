import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  String? className;
  SimpleLogPrinter({this.className});

  @override
  List<String> log(LogEvent event) {
    AnsiColor? color = PrettyPrinter.levelColors[event.level];
    String? emoji = PrettyPrinter.levelEmojis[event.level];

    String message =
        color!('$emoji $className - ${event.message} - ${event.stackTrace}');

    return [message];
  }
}
