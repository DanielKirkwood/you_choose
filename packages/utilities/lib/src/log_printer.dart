import 'package:logger/logger.dart';

/// {@template simplePrintLogger}
/// A simple logger.
/// {@endtemplate}
class SimpleLogPrinter extends LogPrinter {
  /// {@macro simplePrintLogger}
  SimpleLogPrinter({this.className});

  /// the className which the logger is logging information from.
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
