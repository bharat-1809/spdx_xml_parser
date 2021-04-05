import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'golden_file.dart';

final helpGoldenFile = 'test/goldens/license.txt';

void main() {
  test('run spdx_parser shows license with correct format', () async {
    var process = await TestProcess.start('dart', ['run']);
    process.stdin.writeln('MIT');

    var output = await process.stdoutStream().join('\n');

    expectMatchesGoldenFile(output, helpGoldenFile);

    await process.shouldExit();
  });
}
