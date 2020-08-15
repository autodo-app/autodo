import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class NotificationIdUpdated extends NotificationsEvent {
  const NotificationIdUpdated(this.id);

  final int id;

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'NotificationIdUpdated { id: $id }';
}

class ScheduleNotification extends NotificationsEvent {
  const ScheduleNotification(
      {@required this.date, @required this.title, @required this.body});

  final String title, body;

  final DateTime date;

  @override
  List<Object> get props => [date, title, body];

  @override
  String toString() =>
      'ScheduleNotification { date: $date, title: $title, body: $body }';
}

class ReScheduleNotification extends NotificationsEvent {
  const ReScheduleNotification(
      {@required this.id,
      @required this.date,
      @required this.title,
      @required this.body});

  final int id;

  final String title, body;

  final DateTime date;

  @override
  List<Object> get props => [id, date, title, body];

  @override
  String toString() =>
      'ReScheduleNotification { id: $id, date: $date, title: $title, body: $body }';
}

class CancelNotification extends NotificationsEvent {
  const CancelNotification(this.id);

  final int id;

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'CancelNotification { id: $id }';
}
