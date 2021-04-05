import 'package:test/test.dart';

import 'bin_spdx_parser_test.dart' as bin;
import 'formatter_test.dart' as formatter;
import 'spdx_parser_test.dart' as parser;

void main() {
  group('bin_spdx_parser', bin.main);
  group('formatter', formatter.main);
  group('parser', parser.main);
}
