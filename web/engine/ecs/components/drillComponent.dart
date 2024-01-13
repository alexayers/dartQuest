import '../gameComponent.dart';

class DrillComponent implements GameComponent {
  int speed;

  DrillComponent(this.speed);

  @override
  String get name => "drill";
}
