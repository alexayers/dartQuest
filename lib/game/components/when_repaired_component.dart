import '../../engine/ecs/game_component.dart';

class WhenRepairedComponent implements GameComponent {
  Function callback;

  WhenRepairedComponent(this.callback);

  @override
  String get name => "whenRepaired";
}
