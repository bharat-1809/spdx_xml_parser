import 'package:test/test.dart';
import 'package:spdx_xml_parser/src/formatter.dart';

void main() {
  group('normalize symbol codes', () {
    test('format continuous symbol codes', () {
      var input = '&lt;&gt;&#34;';
      expect(preFormatString(input), "<>'");
    });

    test('format separated symbols', () {
      var input = '&#34;Lorem Ipsum&#34; &lt;https://example.com&gt;';
      expect(preFormatString(input), "'Lorem Ipsum' <https://example.com>");
    });
  });

  group('format tags and spaces', () {
    test('handle bullet tags', () {
      var input = '''<bullet>1.</bullet>
                      Point 1
                      <bullet>2. </bullet>
                      Point 2''';
      var expected = '1.Point 1\n2.Point 2\n';
      expect(formatString(input), expected);
    });

    test('handle multiline license tag', () {
      var input = '''<license name="MIT License" isOsiApproved="true"
                    identifier="MIT">
                    No license tag
                  ''';
      var expected = 'No license tag\n';
      expect(formatString(input), expected);
    });

    test('remove unwanted white spaces', () {
      var input = '''Lorem Ipsum
 
             
                  foo bar zoo bar
     
                  lorem''';
      var expected = 'Lorem Ipsum\n\nfoo bar zoo bar\nlorem\n';
      expect(formatString(input), expected);
    });

    test('normalize lists', () {
      var input = '''List
                  <item>
                  	<bullet>1.</bullet>
                  	Point 1
                  </item>
                  <item>
                  	<bullet>2.</bullet>
                  	Point 2
                  	<p>Lorem Ipsum para1
                  		dolo simit evet
                  	</p>
                  	<p>Lorem Ipsum para2
                  		dolo simit evet
                  	</p>
                  </item>''';
      var expected =
          'List\n1.Point 1\n\n2.Point 2\nLorem Ipsum para1\ndolo simit evet\n\nLorem Ipsum para2\ndolo simit evet\n\n\n';
      expect(formatString(input), expected);
    });
  });
}
