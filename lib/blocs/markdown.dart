import 'package:flutter/material.dart';

class _Parser {
  final String Function(String) fn;
  final TextStyle style;

  _Parser(this.fn, this.style);
}

class MarkdownParser {
  static String _list(String line) {
    if (RegExp(r'^- ').hasMatch(line)) {
      List<String> pieces = line.split(RegExp(r'^- '));
      return '•   ' + pieces[1];
    }
    return null;      
  }

  static String _h2(String line) {
    if (RegExp(r'^## ').hasMatch(line)) {
        List<String> pieces = line.split(RegExp(r'^## '));
        return pieces[1];
    }
    return null;
  }

  static TextStyle _h2Style = TextStyle( 
    color: Colors.white.withAlpha(230),
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu',
  );

  static String _h3(String line) {
    if (RegExp(r'^### ').hasMatch(line)) {
        List<String> pieces = line.split(RegExp(r'^### '));
        return pieces[1];
    }
    return null;
  }

  static TextStyle _h3Style = TextStyle( 
    color: Colors.white.withAlpha(230),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu',
  );

  static TextStyle defaultStyle = TextStyle( 
    color: Colors.white.withAlpha(230),
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'IBM Plex Sans',
  );

  static List<_Parser> parsers = [
    _Parser(_h3, _h3Style),
    _Parser(_h2, _h2Style),
  ];

  static List<TextSpan> addLine(List<TextSpan> spans, String txt, TextStyle style) {
    txt += '\n';
    return spans..add(
      TextSpan(
        text: txt,
        style: style ?? defaultStyle,
      )
    );
  }

  static TextStyle bold = defaultStyle.copyWith(fontWeight: FontWeight.w600);

  static List<TextSpan> _inlineMarkup(List<TextSpan> spans, String txt) {
    List<TextSpan> out = [];

    // check for bolding
    // the below regex is kinda black magic and I don't fully understand it
    // modified slightly from https://stackoverflow.com/questions/43633223/dart-split-string-by-regex
    RegExp bolded = RegExp(r"(?:\^\s*-|[^\*\*])+|-");
    var pieces = bolded.allMatches(txt);
    bool odd = false;
    for (var piece in pieces) {
      var match = piece.group(0);
      
      // odd numbered matches (zero aligned) will be bolded sections
      if (odd) {
        out.add(
          TextSpan(  
            text: match,
            style: bold,
          )
        );
      } else {
        out.add(
          TextSpan(  
            text: match,
            style: defaultStyle,
          )
        );
      }
      odd = !odd;
    }

    // italics could be dealt with by a second regex, but that's a problem for later

    out.add(TextSpan(text: '\n')); // make sure that the line ends with a newline character

    return spans + out;
  }

  static List<String> _removeJekyllHeader(List<String> lines) {
    int endJekyllFrontMatter = 0;
    for (var line in lines.getRange(1, lines.length)) {
      if (line.startsWith('---')) {
        endJekyllFrontMatter = lines.indexOf(line, 2);
        break;
      }
    }
    endJekyllFrontMatter += 2; // account for the last '---' line plus a gap space
    return List.from(lines.getRange(endJekyllFrontMatter, lines.length));
  }

  static TextSpan parse(String input) {
    List<String> lines = input.split(RegExp(r'\r?\n'));
    List<TextSpan> spans = [];
    
    lines = _removeJekyllHeader(lines);

    lines.forEach((line) {
      bool parsed = false;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

      // line starting styles - headers, lists, etc.
      for (var parser in parsers) {
        String txt = parser.fn(line); 
        if (txt != null) {
          spans = addLine(spans, txt, parser.style);
          parsed = true;
          break;
        }
      }

      if (!parsed) {
        // line is not special, add with normal style
        line = _list(line) ?? line;
        spans = _inlineMarkup(spans, line);
      }
    });
    return TextSpan(  
      children: spans,
    );
  }
}