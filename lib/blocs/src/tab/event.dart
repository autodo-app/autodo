import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();
}

class UpdateTab extends TabEvent {
  const UpdateTab(this.tab);

  final AppTab tab;

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}
