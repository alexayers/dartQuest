
import '../../../engine/ecs/gameComponent.dart';

class BobAnimationComponent implements GameComponent {

  bool headingDown = true;
  num yOffset = 0;

  @override
  // TODO: implement name
  String get name => "bobAnimation";



}
