import 'game_event.dart';

class ScreenChangeEvent extends GameEvent {
  ScreenChangeEvent(String destinationScreen)
      : super("__CHANGE_SCREEN__", destinationScreen);
}
