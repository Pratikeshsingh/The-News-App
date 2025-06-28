import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

void logMessage(String message, {String name = 'AppLogger'}) {
  if (!kReleaseMode) {
    developer.log(message, name: name);
  }
}
