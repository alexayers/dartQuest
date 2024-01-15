

import '../../gameComponent.dart';

enum MovementStyle {
  wander,
  follow
}

class AiComponent implements GameComponent {


  MovementStyle movementStyle;
  int ticksSinceLastChange = 0;
  int currentDirection = 1;

  AiComponent(this.movementStyle);

  @override
  String get name => "ai";



}
