

import '../../gameComponent.dart';

enum MovementStyle {
  wander,
  follow
}


class AiComponent implements GameComponent {


  MovementStyle movementStyle;
  int ticksSinceLastChange = 0;
  int currentDirection = 1;
  int attackCoolDown = 0;
  bool friend;

  AiComponent(this.movementStyle, this.friend);

  @override
  String get name => "ai";



}
