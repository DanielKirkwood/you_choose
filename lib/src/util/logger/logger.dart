import 'package:logger/logger.dart';
import 'package:you_choose/src/util/logger/log_printer.dart';

Logger getLogger(String? className) {
  return Logger(printer: SimpleLogPrinter(className: className));
}
