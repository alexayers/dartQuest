import '../../engine/ecs/gameComponent.dart';

class WhenDestroyedComponent implements GameComponent {
  Function callback;

  WhenDestroyedComponent(this.callback);

  @override
  String get name => "whenDestroyed";
}
