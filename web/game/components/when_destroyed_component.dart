import '../../engine/ecs/game_component.dart';

class WhenDestroyedComponent implements GameComponent {
  Function callback;

  WhenDestroyedComponent(this.callback);

  @override
  String get name => "whenDestroyed";
}
