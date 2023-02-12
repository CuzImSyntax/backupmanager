import 'package:flutter/foundation.dart';

class ButtonProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map<int, bool> dryRunMap = {};

  void changeDryRunMap(int id, bool value) {
    dryRunMap[id] = value;
    notifyListeners();
  }

  bool getDryRunMapItem(int id) {
    return dryRunMap.containsKey(id) ? dryRunMap[id]! : false;
  }
}
