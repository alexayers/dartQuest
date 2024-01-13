class GlobalState {
  static final Map<String, dynamic> _globalState = new Map();

  static createState(String key, dynamic value) {
    _globalState[key] = value;
  }

  static dynamic getState(String key) {
    return _globalState[key];
  }

  static bool hasState(String key) {
    return _globalState.containsKey(key);
  }

  static void removeWhere(String partialKey) {
    _globalState.removeWhere((key, value) => key.startsWith(partialKey));
  }
}
