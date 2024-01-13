class TimerUtil {
  var _startTime = 0;

  var _waitTime = 0;

  TimerUtil(var waitTime) {
    _waitTime = waitTime;
  }

  void start(var waitTime) {
    _waitTime = _waitTime;
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void reset() {
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  bool hasTimePassed() {
    return _startTime + _waitTime < DateTime.now().millisecondsSinceEpoch;
  }
}
