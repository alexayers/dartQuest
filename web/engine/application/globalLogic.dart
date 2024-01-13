class GlobalLogic {
  final List<Function> _globalCallbacks = [];

  void registerLogic(Function function) {
    _globalCallbacks.add(function);
  }

  void execute() {
    for (var callback in _globalCallbacks) {
      callback();
    }
  }
}
