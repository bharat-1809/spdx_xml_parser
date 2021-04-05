/// The library contains methods to normalize and format the xml string

/// Preformats the xml string to replace special char codes to literal char
String preFormatString(String xmlString) {
  var str = _normalizeTagOrSymbol(text: xmlString, pattern: _gtSymbolRegex, replacement: '>');
  str = _normalizeTagOrSymbol(text: str, pattern: _ltSymbolRegex, replacement: '<');
  str = _normalizeTagOrSymbol(text: str, pattern: _quoteSymbolRegex, replacement: "'");
  return str;
}

/// Format the xml string to remove tags and extraneous spaces
/// Tags that are removed: bullet, license, obsoletedBy, crossRef
String formatString(String xmlString) {
  // Remove the end bullet tag and normalize the text
  var str = _removeSplitJoin(text: xmlString, pattern: _bulletEndRegex);

  // Remove the corresponding tags
  str = _normalizeTagOrSymbol(text: str, pattern: _licenseTagRegex, replacement: '');
  str = _normalizeTagOrSymbol(text: str, pattern: _obsoletedTagRegex, replacement: '');
  str = _normalizeTagOrSymbol(text: str, pattern: _crossRefTagRegex, replacement: '');
  str = _normalizeTagOrSymbol(text: str, pattern: _notesTagRegex, replacement: '');
  str = _normalizeTagOrSymbol(text: str, pattern: _paraTagRegex, replacement: '\n ');
  str = _normalizeTagOrSymbol(text: str, pattern: _otherXmlTagsRegex, replacement: '');

  // Remove the extraneous spaces, skipping the required ones like the new line after each para
  str = _removeSplitJoin(
    text: str,
    pattern: _unwantedSpacesRegex,
    joinAddOn: '\n',
    joinIfRegex: _unwantedSpaceConditionRegex,
  );

  return str;
}

// Regex for normalizing symbols
final _gtSymbolRegex = RegExp(r'&gt;');
final _ltSymbolRegex = RegExp(r'&lt;');
final _quoteSymbolRegex = RegExp(r'&#34;');

// Regex for normalizing tags
final _bulletEndRegex = RegExp('</bullet>\n');
final _licenseTagRegex = RegExp('((<license(.*)\n )(.*)\n )(.*)\n');
final _obsoletedTagRegex = RegExp('<obsoletedBy(.*)');
final _crossRefTagRegex = RegExp('<crossRef(.*)');
final _notesTagRegex = RegExp('<notes(.*)');
final _paraTagRegex = RegExp(r'</p>');
final _otherXmlTagsRegex = RegExp('<(.*?)>');

// Regex for normalizing white spaces
final _unwantedSpacesRegex = RegExp('\n');
final _unwantedSpaceConditionRegex = RegExp('[A-Z]|[a-z]|[0-9]|^ {1}', multiLine: true);

/// Normalize the tag or symbol in the text that matches the pattern.
String _normalizeTagOrSymbol(
    {required String text, required RegExp pattern, required String replacement}) {
  final formattedText = text.replaceAll(pattern, replacement);
  return formattedText;
}

/// Split the text at the pattern and join after trimming and add the joinAddOn while joining
/// joinIfRegex determines whether the spliited part should be joined or not
String _removeSplitJoin(
    {required String text, required RegExp pattern, String? joinAddOn, RegExp? joinIfRegex}) {
  final stringList = text.split(pattern);
  var tempString = '';

  for (var str in stringList) {
    if (joinIfRegex?.hasMatch(str) ?? true) {
      tempString += (str.trim() + '${joinAddOn ?? ''}');
    }
  }

  return tempString;
}
