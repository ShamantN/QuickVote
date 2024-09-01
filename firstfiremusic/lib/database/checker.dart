import 'package:hive/hive.dart';

class Check {
  int store = 0;
  var box = Hive.box('checkLogin');

  void createData() {
    store = 0;
  }

  void writeLog() {
    box.put("1", store);
  }

  void readLog() {
    store = -1;
  }
}
