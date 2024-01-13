import '../../engine/ecs/gameComponent.dart';

class RepairComponent implements GameComponent {
  int speed;

  RepairComponent(this.speed);

  @override
  String get name => "repair";
}
