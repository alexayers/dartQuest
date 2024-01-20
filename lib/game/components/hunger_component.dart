import '../../engine/ecs/game_component.dart';

class HungerComponent implements GameComponent {
  int max;
  int current;

  HungerComponent(this.current, this.max);

  @override
  String get name => "hunger";
}
