import '../../engine/ecs/game_component.dart';

class StaminaComponent implements GameComponent {
  int max;
  int current;

  StaminaComponent(this.current, this.max);

  @override
  String get name => "stamina";
}
