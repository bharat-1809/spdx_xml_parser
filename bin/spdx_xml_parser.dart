import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main(List<String> arguments) async {
  var pen = AnsiPen()..magenta(bold: true);
  print(pen('\n-------------- SPDX XML License Parser --------------\n'));

  /// Get the license as String
  var _licenseIdentifier = await getUserResponse();
  var _xmlString = await getLicense(_licenseIdentifier);

  /// Preformat the xml string
  var _formattedString = preFormatXmlString(_xmlString);

  /// Print the license details
  printLicenseDetails(_formattedString);

  /// Format the xml string to remove unwanted tags
  var _stripedText = formatXmlString(_formattedString);

  /// Print the license text
  print(_stripedText);
}

/// Get user response
Future<String> getUserResponse() async {
  var _pen = AnsiPen()..cyan();
  print(_pen(
    'Enter an SPDX license identifier to fetch the license:\nLike 0BSD, Apache-2.0 or MIT, etc (Case Sensitive)\n',
  ));

  var _licenseIdentifier = stdin.readLineSync();
  return _licenseIdentifier ?? 'Error: No response from user';
}

/// Get a license file based on the response got from user
Future<String> getLicense(String licenseIdentifier) async {
  final _url =
      'https://raw.githubusercontent.com/spdx/license-list-XML/master/src/$licenseIdentifier.xml';
  final _uri = Uri.parse(_url);

  print('Fetching license...');
  var _response = await http.get(_uri);

  if (_response.statusCode != 200) {
    var _pen = AnsiPen()..red(bold: true);
    return Future.error(_pen('Error: ${_response.body}\n'));
  }

  print('License fetched!\n');
  return _response.body;
}

/// Print the license details viz name, spdx-identifier, osi approved license, deprecated.
void printLicenseDetails(String xmlString) {
  var keyPen = AnsiPen()..yellow();
  var valuePen = AnsiPen()..green(bold: true);

  var _licenseName = getLicenseDetails(xmlString: xmlString, regex: 'name="');
  var _licenseId = getLicenseDetails(xmlString: xmlString, regex: 'licenseId="');
  var _isOsiApproved = getLicenseDetails(xmlString: xmlString, regex: 'isOsiApproved="');
  var _isDeprecated = getLicenseDetails(xmlString: xmlString, regex: 'isDeprecated="');
  var _deprecatedVersion = getLicenseDetails(xmlString: xmlString, regex: 'deprecatedVersion="');

  print(keyPen('License name: ') + valuePen('$_licenseName'));
  print(keyPen('SPDX identifier: ') + valuePen('$_licenseId'));
  print(keyPen('Is OSI approved: ') + valuePen('$_isOsiApproved'));
  if (_isDeprecated == 'true') {
    print(keyPen('Is deprecated: ') + valuePen('$_isDeprecated'));
    print(keyPen('Deprecated version: ') + valuePen('$_deprecatedVersion'));
  }
}

/// Get license details using regex
String? getLicenseDetails({required String xmlString, required String regex}) {
  var _detailRegex = RegExp('$regex');
  var _detailIndex = xmlString.indexOf(_detailRegex);

  if (_detailIndex == -1) return null;
  _detailIndex += regex.length;

  var _detail = '';
  var _currentChar = xmlString[_detailIndex];

  while (_currentChar != '"') {
    _detail += _currentChar;
    _detailIndex += 1;
    _currentChar = xmlString[_detailIndex];
  }

  return _detail;
}

/// Preformats the xml string to replace special char codes to literal char
String preFormatXmlString(String xmlString) {
  var _formattedString = xmlString;

  var _gtSymbolRegex = RegExp(r'&gt;');
  _formattedString = _formattedString.replaceAll(_gtSymbolRegex, '>');

  var _ltSymbolRegex = RegExp(r'&lt;');
  _formattedString = _formattedString.replaceAll(_ltSymbolRegex, '<');

  var _quoteSymbolRegex = RegExp(r'&#34;');
  _formattedString = _formattedString.replaceAll(_quoteSymbolRegex, "'");

  return _formattedString;
}

/// Format the xml string to remove tags
/// Tags that are removed: bullet, license, obsoletedBy, crossRef
String formatXmlString(String xmlString) {
  var _formattedString = xmlString;
  var _tempString = '';
  List<String> _stringList;

  /// Handle the <bullet> tag
  var _bulletEndRegex = RegExp('</bullet>\n');
  _stringList = _formattedString.split(_bulletEndRegex);
  for (var str in _stringList) {
    _tempString += (str.trim());
  }
  _formattedString = _tempString;

  /// Remove the <license> tag and contents
  var _licenseTagRegex = RegExp('((<license(.*)\n )(.*)\n )(.*)\n');
  _formattedString = _formattedString.replaceAll(_licenseTagRegex, '');

  /// Remove the <obsoletedBy> tag and contents
  var _obsoletedTagRegex = RegExp('<obsoletedBy(.*)');
  _formattedString = _formattedString.replaceAll(_obsoletedTagRegex, '');

  /// Remove the <crossRef> tag and contents
  var _crossRefTagRegex = RegExp('<crossRef(.*)');
  _formattedString = _formattedString.replaceAll(_crossRefTagRegex, '');

  /// Remove the <crossRef> tag and contents
  var _notesTagRegex = RegExp('<notes(.*)');
  _formattedString = _formattedString.replaceAll(_notesTagRegex, '');

  var _paraTagRegex = RegExp(r'</p>');
  _formattedString = _formattedString.replaceAll(_paraTagRegex, '\n ');

  /// Remove all tags
  var _xmlTagsRegex = RegExp('<(.*?)>');
  _formattedString = _formattedString.replaceAll(_xmlTagsRegex, '');

  /// Remove unwanted white spaces
  var _unwantedSpacesRegex = RegExp(r'\n|\t');
  _stringList = _formattedString.split(_unwantedSpacesRegex);
  _tempString = '';
  var _charRegex = RegExp('[A-Z]|[a-z]|[0-9]|^ {1}', multiLine: true);
  for (var str in _stringList) {
    if (_charRegex.hasMatch(str)) {
      _tempString += (str.trim() + '\n');
    }
  }
  _formattedString = _tempString;
  return _formattedString;
}
