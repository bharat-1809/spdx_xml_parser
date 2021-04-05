import 'package:ansicolor/ansicolor.dart';
import 'package:http/http.dart' as http;

/// Get a license file based on the response got from user
Future<String> getLicense(String licenseIdentifier) async {
  final url = '$_spdxMasterFileUrl/$licenseIdentifier.xml';
  final uri = Uri.parse(url);

  print('Fetching license...');
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    var pen = AnsiPen()..red(bold: true);
    return Future.error(pen('Error: ${response.body}\n'));
  }

  print('License fetched!\n');
  return response.body;
}

/// Print the license details viz name, spdx-identifier, osi approved license, deprecated.
void printLicenseDetails(String xmlString) {
  var keyPen = AnsiPen()..yellow();
  var valuePen = AnsiPen()..green(bold: true);

  var licenseName = _getLicenseDetails(xmlString: xmlString, propertyName: 'name');
  var licenseId = _getLicenseDetails(xmlString: xmlString, propertyName: 'licenseId');
  var isOsiApproved = _getLicenseDetails(xmlString: xmlString, propertyName: 'isOsiApproved');
  var isDeprecated = _getLicenseDetails(xmlString: xmlString, propertyName: 'isDeprecated');
  var deprecatedVersion = _getLicenseDetails(xmlString: xmlString, propertyName: 'deprecatedVersion');

  print(keyPen('License name: ') + valuePen('$licenseName'));
  print(keyPen('SPDX identifier: ') + valuePen('$licenseId'));
  print(keyPen('Is OSI approved: ') + valuePen('$isOsiApproved'));
  if (isDeprecated == 'true') {
    print(keyPen('Is deprecated: ') + valuePen('$isDeprecated'));
    print(keyPen('Deprecated version: ') + valuePen('$deprecatedVersion'));
  }
  print('\n');
}

final _spdxMasterFileUrl = 'https://raw.githubusercontent.com/spdx/license-list-XML/master/src';

/// Get license details using regex
String? _getLicenseDetails({required String xmlString, required String propertyName}) {
  var detailRegex = RegExp('(?<=$propertyName=")(.*?)(?=")');
  var detail = detailRegex.stringMatch(xmlString);

  return detail;
}
