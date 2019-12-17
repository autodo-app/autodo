import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/blocs/todos/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

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
  static TextStyle _linkStyle = defaultStyle.copyWith(
      decoration: TextDecoration.underline, color: Colors.blue);

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

    RegExp isLink = RegExp(r'\[(.*?)\]\((.*?)\)');
    // List containing entries with the past text span and the new text span
    List<List<TextSpan>> toRemove = [];
    for (var span in out) {
      var txt = span.text;
      // dynamically resizing the list is bad
      TextSpan t = TextSpan(text: '', children: []);
      var pieces = isLink.allMatches(txt);
      for (var piece in pieces) {
        var fullMatch = piece.group(0);
        var splitString = txt.split(fullMatch);
        bool odd = false;
        for (var s in splitString) {
          if (odd) {
            var url = piece.group(2);
            var linkText = piece.group(1);
            var tap = TapGestureRecognizer()
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
      var idx = out.indexOf(pair[0]);
      out[idx] = pair[1];
    }

    // italics could be dealt with by another regex, but that's a problem for later

    out.add(TextSpan(
        text: '\n')); // make sure that the line ends with a newline character

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
    endJekyllFrontMatter +=
        2; // account for the last '---' line plus a gap space
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


class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateTodos((todosBloc.state as TodosLoaded).todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState {
    return todosBloc.state is TodosLoaded
        ? FilteredTodosLoaded(
            (todosBloc.state as TodosLoaded).todos,
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is UpdateTodosFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateTodos) {
      yield* _mapTodosUpdatedToState(event);
    }
  }

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    UpdateTodosFilter event,
  ) async* {
    if (todosBloc.state is TodosLoaded) {
      yield FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoaded).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    UpdateTodos event,
  ) async* {
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoaded).todos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.completed;
      } else {
        return todo.completed;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}

static Future<String> loadAsset(context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('legal/privacy-policy.md');
  }

  static RichText txt;

  static void init(BuildContext context) async {
    var text = await loadAsset(context);
    txt = RichText(text: MarkdownParser.parse(text));
  }

  static Widget text() {
    return txt;
  }