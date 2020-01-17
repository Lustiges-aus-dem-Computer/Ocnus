import 'package:logger/logger.dart';

// Top-Level function for logging
Logger getLogger() {
  return Logger(printer: PrettyPrinter());
}