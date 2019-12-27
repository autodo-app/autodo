import 'package:flutter/material.dart';

class IntegrationTestKeys {
  static const Key welcomeScreen = ValueKey('__welcome_screen__');
  static const Key signupScreen = ValueKey('__signup_screen__');
  static const Key homeScreen = ValueKey('__home_screen__');
  static const Key fabKey = ValueKey('__fab__');
  static const Key mainFab = ValueKey('__main_fab__');
  static const List<Key> fabKeys = [  
    ValueKey('new_refueling_fab'),
    ValueKey('new_todo_fab'),
    ValueKey('new_repeat_fab')
  ];
  static const Key addEditTodo = ValueKey('__add_edit_todo__');
}