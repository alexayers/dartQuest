class GameEvent {
  final String _channel;
  final dynamic _payload;

  GameEvent(this._channel, this._payload);

  String get channel => _channel;

  dynamic get payload => _payload;
}
