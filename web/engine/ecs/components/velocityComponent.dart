import '../gameComponent.dart';

class VelocityComponent implements GameComponent {
  num velX;
  num velY;
  bool rotateRight = false;
  bool rotateLeft = false;

  VelocityComponent(int valueX, int valueY)
      : velX = valueX,
        velY = valueY;

  @override
  String get name => "velocity";
}
