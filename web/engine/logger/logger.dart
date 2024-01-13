enum LogType { info, debug, error }

void logger(LogType logType, String msg) {
  var date = DateTime.now();
  var dateString = date.toIso8601String();

  switch (logType) {
    case LogType.info:
      print('$dateString - INFO - $msg');
      break;
    case LogType.error:
      print('$dateString - ERROR - $msg');
      break;
    case LogType.debug:
      print('$dateString - DEBUG - $msg');
      break;
  }
}
