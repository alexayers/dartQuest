import '../gameComponent.dart';

class PositionComponent implements GameComponent {
  int x;
  int y;

  PositionComponent(int valueX, int valueY)
      : x = valueX,
        y = valueY;

  @override
  String get name => "position";
}
