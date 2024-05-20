import 'dart:developer' as devs show log;

const String? test = bool.hasEnvironment('TEST') ? String.fromEnvironment('TEST') : null;

extension Logger on Object {
  void log() {
    // logging only in TEST mode
    if (test == 'true') {
      devs.log('Logger::[${toString()}]');
    } else if (test == 'print') {
      print('Logger::[${toString()}]');
    }
    // otherwise no action
  }
}
