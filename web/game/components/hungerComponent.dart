import '../../engine/ecs/gameComponent.dart';

class HungerComponent implements GameComponent {
  int max;
  int current;

  HungerComponent(this.current, this.max);

  @override
  String get name => "hunger";
}
