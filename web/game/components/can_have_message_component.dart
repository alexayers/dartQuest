import '../../engine/ecs/game_component.dart';

class CanHaveMessageComponent implements GameComponent {
  Function callback;

  CanHaveMessageComponent(this.callback);

  @override
  String get name => "canHave";
}
