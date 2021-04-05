import 'dart:io';

import 'package:test/test.dart';

/// Will test actual against the contests of the file at goldenFilePath.
///
/// If the file doesn't exist, the file is instead created containing actual.
void expectMatchesGoldenFile(String actual, String goldenFilePath) {
  var goldenFile = File(goldenFilePath);
  if (goldenFile.existsSync()) {
    expect(
      actual,
      equals(goldenFile.readAsStringSync().replaceAll('\r\n', '\n')),
      reason: 'goldenFilePath: "$goldenFilePath". '
          'To update the expectation delete this file and rerun the test.',
    );
  } else {
    goldenFile
      ..createSync(recursive: true)
      ..writeAsStringSync(actual);
    fail('Golden file $goldenFilePath was recreated!');
  }
}
