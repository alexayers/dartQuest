import '../../engine/ecs/game_component.dart';

class RepairComponent implements GameComponent {
  int speed;

  RepairComponent(this.speed);

  @override
  String get name => "repair";
}
