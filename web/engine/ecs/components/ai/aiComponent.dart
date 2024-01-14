

import '../../gameComponent.dart';

class AiComponent implements GameComponent {

  int ticksSinceLastChange = 0;
  int currentDirection = 1;

  @override
  String get name => "ai";



}
