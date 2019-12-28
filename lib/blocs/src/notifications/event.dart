import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class NotificationIdUpdated extends NotificationsEvent {
  final int id;

  const NotificationIdUpdated(this.id);

  @override
  List<Object> get props => [id];

  @override
  toString() => "NotificationIdUpdated { id: $id }";
}

class ScheduleNotification extends NotificationsEvent {
  final String title, body;
  final DateTime date;

  const ScheduleNotification(
      {@required this.date, @required this.title, @required this.body});

  @override
  List<Object> get props => [date, title, body];

  @override
  toString() =>
      "ScheduleNotification { date: $date, title: $title, body: $body }";
}

class ReScheduleNotification extends NotificationsEvent {
  final int id;
  final String title, body;
  final DateTime date;

  const ReScheduleNotification(
      {@required this.id,
      @required this.date,
      @required this.title,
      @required this.body});

  @override
  List<Object> get props => [id, date, title, body];

  @override
  toString() =>
      "ReScheduleNotification { id: $id, date: $date, title: $title, body: $body }";
}

class CancelNotification extends NotificationsEvent {
  final int id;

  const CancelNotification(this.id);

  @override
  List<Object> get props => [id];

  @override
  toString() => "CancelNotification { id: $id }";
}
