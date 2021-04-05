import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

/// Get user response
Future<String> getUserResponse() async {
  var pen = AnsiPen()..cyan();
  print(pen(
    'Enter an SPDX license identifier to fetch the license:\nLike 0BSD, Apache-2.0 or MIT, etc (Case Sensitive)\n',
  ));

  final licenseIdentifier = stdin.readLineSync();
  return licenseIdentifier ?? 'Error: No response from user';
}
