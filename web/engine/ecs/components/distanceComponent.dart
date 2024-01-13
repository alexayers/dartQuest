import '../gameComponent.dart';

class DistanceComponent implements GameComponent {
  num distance;

  DistanceComponent([num value = 0]) : distance = value;

  @override
  String get name => "distance";
}
