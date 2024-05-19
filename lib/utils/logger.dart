import 'dart:developer' as devs show log;

const String? test = bool.hasEnvironment('TEST') ? String.fromEnvironment('TEST') : null;

extension Logger on Object {
  void log() {
    // logging only in TEST mode
    if (test != null) {
      devs.log('Logger::[${toString()}]');
    }
    // otherwise no action
  }
}
