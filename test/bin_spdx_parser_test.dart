import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'golden_file.dart';

final helpGoldenErrorPath = 'test/goldens/error.txt';
final helpGoldenInfoPath = 'test/goldens/info.txt';

void main() {
  test('shows correct info and bad license name shows error', () async {
    var process = await TestProcess.start('dart', ['run']);
    process.stdin.writeln('bogus_license');

    var output = await process.stdoutStream().join('\n');
    var error = await process.stderrStream().join('\n');

    expectMatchesGoldenFile(output, helpGoldenInfoPath);
    expectMatchesGoldenFile(error, helpGoldenErrorPath);

    await process.shouldExit();
  });
}
