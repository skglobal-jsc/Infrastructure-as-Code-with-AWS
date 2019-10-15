import 'dart:io';
import 'package:flutter/foundation.dart';

typedef CreateModelFromJson = dynamic Function(Map<String, dynamic>);
typedef CreateModelInitial = dynamic Function();

class FileInfo {
  final File file;
  final String field;
  FileInfo({@required this.file, @required this.field});
}

class ErrorInfo {
  final int code;
  final String message;
  ErrorInfo({this.code, this.message});
}

enum SearchableAttribute {
  email,
  name,
  username,
}

enum SearchableType {
  BEGIN_WITH,
  EXTRACTLY,
}
