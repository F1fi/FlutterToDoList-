import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/pages/ToDoList.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(primaryColor: Colors.blue),
  home: ToDoList()
));