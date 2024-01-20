import '../../engine/ecs/game_component.dart';

class OxygenComponent implements GameComponent {
  int max;
  int current;

  OxygenComponent(this.current, this.max);

  @override
  String get name => "oxygen";
}
