import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LegalState extends Equatable {
  const LegalState();

  @override
  List<Object> get props => [];
}

class LegalNotLoaded extends LegalState {}

class LegalLoading extends LegalState {}

class LegalLoaded extends LegalState {
  const LegalLoaded({this.text});

  final RichText text;

  @override
  List<Object> get props => [text.text.toPlainText()];

  @override
  String toString() {
    return 'LegalLoaded { text: $text }';
  }
}
