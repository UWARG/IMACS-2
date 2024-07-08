import 'dart:developer';

void logDroneMode(int? currentMode, String? currentModeName) {
  if (currentMode != null) {
    log("$currentModeName mode selected.");
  } else {
    log('No mode selected.');
  }
}
