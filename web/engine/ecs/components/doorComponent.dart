import '../gameComponent.dart';

class DoorComponent implements GameComponent {
  bool open = false;

  void openDoor() {
    open = true;
  }

  void closeDoor() {
    open = false;
  }

  bool isOpen() {
    return open;
  }

  @override
  String get name => "door";
}
