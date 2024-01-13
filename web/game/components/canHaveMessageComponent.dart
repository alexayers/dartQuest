import '../../engine/ecs/gameComponent.dart';

class CanHaveMessageComponent implements GameComponent {
  Function callback;

  CanHaveMessageComponent(this.callback);

  @override
  String get name => "canHave";
}
