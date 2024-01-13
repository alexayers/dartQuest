import '../gameComponent.dart';

class DamageComponent implements GameComponent {
  int amount;

  DamageComponent(this.amount);

  @override
  String get name => "damage";
}
