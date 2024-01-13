import '../../gameComponent.dart';

class CanInteractComponent implements GameComponent {
  Function? callBack;

  CanInteractComponent([this.callBack]);

  @override
  String get name => "canInteract";
}
