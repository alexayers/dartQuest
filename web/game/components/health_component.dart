import '../../engine/ecs/game_component.dart';

class HealthComponent implements GameComponent {
  int max;
  int current;

  HealthComponent(this.current, this.max);

  @override
  String get name => "health";
}
