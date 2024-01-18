import 'package:flutter/foundation.dart';

/// Provides button states for the dryRun buttons.
class ButtonProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map<int, bool> dryRunMap = {};

  /// Sets the button with the given [id] to the given [value].
  void changeDryRunMap(int id, bool value) {
    dryRunMap[id] = value;
    notifyListeners();
  }

  /// Returns the state of the button with the given [id].
  bool getDryRunMapItem(int id) {
    return dryRunMap.containsKey(id) ? dryRunMap[id]! : false;
  }
}
