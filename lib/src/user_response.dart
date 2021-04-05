import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

/// Get user response
Future<String> getUserResponse() async {
  var _pen = AnsiPen()..cyan();
  print(_pen(
    'Enter an SPDX license identifier to fetch the license:\nLike 0BSD, Apache-2.0 or MIT, etc (Case Sensitive)\n',
  ));

  var _licenseIdentifier = stdin.readLineSync();
  return _licenseIdentifier ?? 'Error: No response from user';
}
