import '../../rendering/rayCaster/camera.dart';
import '../game_component.dart';

class CameraComponent implements GameComponent {
  Camera camera;

  CameraComponent(this.camera);

  @override
  String get name => "camera";
}
