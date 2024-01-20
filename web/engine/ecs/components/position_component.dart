import '../game_component.dart';

class PositionComponent implements GameComponent {
  num x;
  num y;

  PositionComponent(num valueX, num valueY)
      : x = valueX,
        y = valueY;

  @override
  String get name => "position";
}
