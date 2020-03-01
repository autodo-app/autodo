import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'event.dart';
import 'state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class _Parser {
  _Parser(this.fn, this.style);

  final String Function(String) fn;

  final TextStyle style;
}

class MarkdownParser {
  static String _list(String line) {
    if (RegExp(r'^- ').hasMatch(line)) {
      final pieces = line.split(RegExp(r'^- '));
      return '•   ${pieces[1]}';
    }
    return null;
  }

  static String _h2(String line) {
    if (RegExp(r'^## ').hasMatch(line)) {
      final pieces = line.split(RegExp(r'^## '));
      return pieces[1];
    }
    return null;
  }

  static final TextStyle _h2Style = TextStyle(
    color: Colors.white.withAlpha(230),
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'Ubuntu',
  );

  static String _h3(String line) {
    if (RegExp(r'^### ').hasMatch(line)) {
      final pieces = line.split(RegExp(r'^### '));
      return pieces[1];
    }
    return null;
  }

  static final TextStyle _h3Style = TextStyle(
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

  static List<TextSpan> addLine(
      List<TextSpan> spans, String txt, TextStyle style) {
    txt += '\n';
    return spans
      ..add(TextSpan(
        text: txt,
        style: style ?? defaultStyle,
      ));
  }

  static TextStyle bold = defaultStyle.copyWith(fontWeight: FontWeight.w600);
  static final TextStyle _linkStyle = defaultStyle.copyWith(
      decoration: TextDecoration.underline, color: Colors.blue);

  static List<TextSpan> _inlineMarkup(List<TextSpan> spans, String txt) {
    final out = <TextSpan>[];

    // check for bolding
    // the below regex is kinda black magic and I don't fully understand it
    // modified slightly from https://stackoverflow.com/questions/43633223/dart-split-string-by-regex
    final bolded = RegExp(r'(?:\^\s*-|[^\*\*])+|-');
    final pieces = bolded.allMatches(txt);
    var odd = false;
    for (var piece in pieces) {
      final match = piece.group(0);

      // odd numbered matches (zero aligned) will be bolded sections
      if (odd) {
        out.add(TextSpan(
          text: match,
          style: bold,
        ));
      } else {
        out.add(TextSpan(
          text: match,
          style: defaultStyle,
        ));
      }
      odd = !odd;
    }

    final isLink = RegExp(r'\[(.*?)\]\((.*?)\)');
    // List containing entries with the past text span and the new text span
    final toRemove = <List<TextSpan>>[];
    for (var span in out) {
      final txt = span.text;
      // dynamically resizing the list is bad
      final t = TextSpan(text: '', children: []);
      final pieces = isLink.allMatches(txt);
      for (var piece in pieces) {
        final fullMatch = piece.group(0);
        final splitString = txt.split(fullMatch);
        var odd = false;
        for (var s in splitString) {
          if (odd) {
            final url = piece.group(2);
            final linkText = piece.group(1);
            final tap = TapGestureRecognizer()
              ..onTap = () => launcher.launch(url);
            t.children.add(TextSpan(
              text: linkText,
              recognizer: tap,
              style: _linkStyle,
            ));
          }
          t.children.add(TextSpan(
            text: s,
            style: defaultStyle,
          ));
          odd = !odd;
        }
      }
      if (isLink.hasMatch(txt)) {
        toRemove.add([span, t]);
      }
    }
    for (var pair in toRemove) {
      final idx = out.indexOf(pair[0]);
      out[idx] = pair[1];
    }

    // italics could be dealt with by another regex, but that's a problem for later

    out.add(TextSpan(
        text: '\n')); // make sure that the line ends with a newline character

    return spans + out;
  }

  static List<String> _removeJekyllHeader(List<String> lines) {
    var endJekyllFrontMatter = 0;
    for (var line in lines.getRange(1, lines.length)) {
      if (line.startsWith('---')) {
        endJekyllFrontMatter = lines.indexOf(line, 2);
        break;
      }
    }
    endJekyllFrontMatter +=
        2; // account for the last '---' line plus a gap space
    return List.from(lines.getRange(endJekyllFrontMatter, lines.length));
  }

  static TextSpan parse(String input) {
    var lines = input.split(RegExp(r'\r?\n'));
    var spans = <TextSpan>[];

    lines = _removeJekyllHeader(lines);

    lines.forEach((line) {
      var parsed = false;

      // line starting styles - headers, lists, etc.
      for (var parser in parsers) {
        final txt = parser.fn(line);
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

class LegalBloc extends Bloc<LegalEvent, LegalState> {
  LegalBloc({@required bundle})
      : assert(bundle != null),
        _bundle = bundle;

  final AssetBundle _bundle;

  @override
  LegalState get initialState => LegalNotLoaded();

  @override
  Stream<LegalState> mapEventToState(LegalEvent event) async* {
    if (event is LoadLegal) {
      yield* _mapLoadLegalToState();
    }
  }

  Stream<LegalState> _mapLoadLegalToState() async* {
    yield LegalLoading();
    final rawText = await _bundle.loadString('legal/privacy-policy.md');
    final richText = RichText(text: MarkdownParser.parse(rawText));
    yield LegalLoaded(text: richText);
  }
}
