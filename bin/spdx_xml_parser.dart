import 'package:spdx_xml_parser/spdx_xml_parser.dart';
import 'package:ansicolor/ansicolor.dart';

void main(List<String> arguments) async {
  var pen = AnsiPen()..magenta(bold: true);
  print(pen('\n-------------- SPDX XML License Parser --------------\n'));

  final licenseIdentifier = await getUserResponse();
  final xmlString = await getLicense(licenseIdentifier);

  // Preformat the xml string
  // Its necessary as in some cases the license name may contain a symbol code
  // that needs to be normalized to get pretty license details
  var formattedString = preFormatString(xmlString);
  printLicenseDetails(formattedString);

  // Format the xml string to remove extra spaces and tags
  var stripedText = formatString(formattedString);
  print(stripedText);
}