import '../../engine/ecs/gameComponent.dart';

class WhenRepairedComponent implements GameComponent {
  Function callback;

  WhenRepairedComponent(this.callback);

  @override
  String get name => "whenRepaired";
}
