import '../../engine/ecs/gameComponent.dart';

class SuitComponent implements GameComponent {
  int max;
  int current;

  SuitComponent(this.current, this.max);

  @override
  String get name => "suit";
}
