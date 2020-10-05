import 'package:meta/meta.dart';

import '../../models/models.dart';

class SetTodosFilterAction {
  const SetTodosFilterAction({@required this.filter});

  final VisibilityFilter filter;
}

class SetRefuelingsFilterAction {
  const SetRefuelingsFilterAction({@required this.filter});

  final VisibilityFilter filter;
}
