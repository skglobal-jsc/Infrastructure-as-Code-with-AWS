import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_info.dart';
import '../services/definitions.dart';

class StorageService {
  var _infoMap = Map<String, dynamic>();

  Future<void> loadAllInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadInfo<UserInfo>(prefs, () => UserInfo(), (map) => UserInfo.fromJson(map));
  }

  Future<void> resetAllInfo() async {
    setInfo<UserInfo>(UserInfo(), hasSave: true);
  }

  T getInfo<T>() {
    return _infoMap[T.toString()] as T;
  }

  Future<void> setInfo<T>(dynamic info, {bool hasSave = false}) async {
    _infoMap[T.toString()] = info;
    if (hasSave) {
      String encoded = json.encode(info.toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(T.toString(), encoded);
    }
  }

  // utility
  void _loadInfo<T>(SharedPreferences prefs, CreateModelInitial fromInitial, CreateModelFromJson fromJson){
    String string = prefs.getString(T.toString());
    if (string != null) {
      dynamic decoded = json.decode(string);
      _infoMap[T.toString()] = fromJson(decoded);
    }
    else {
      _infoMap[T.toString()] = fromInitial();
    }
  }
}
