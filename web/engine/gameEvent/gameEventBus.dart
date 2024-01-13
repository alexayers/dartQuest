import '../logger/logger.dart';
import 'gameEvent.dart';

class GameEventBus {
  static Map<String, List<Function>> _channels = Map();

  static void register(String channel, Function eventHandler) {
    if (!GameEventBus._channels.containsKey(channel)) {
      logger(LogType.info, "Creating new channel -> $channel");
      GameEventBus._channels[channel] = [];
    }

    GameEventBus._channels[channel]?.add(eventHandler);
  }

  static void publish(GameEvent gameEvent) {
    if (GameEventBus._channels.containsKey(gameEvent.channel)) {
      List<Function>? listeners = GameEventBus._channels[gameEvent.channel];

      for (var listener in listeners!) {
        try {
          listener(gameEvent);
        } catch (e) {
          logger(LogType.error, e.toString());
        }
      }
    } else {
      logger(LogType.error,
          'No listeners registered for channel -> $gameEvent.channel');
    }
  }
}
