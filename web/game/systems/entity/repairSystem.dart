import '../../../engine/ecs/gameEntity.dart';
import '../../../engine/ecs/gameSystem.dart';

class RepairSystem implements GameSystem {
  @override
  void processEntity(GameEntity gameEntity) {
    // TODO: implement processEntity
  }

  @override
  void removeIfPresent(GameEntity gameEntity) {
    // TODO: implement removeIfPresent
  }

  @override
  bool shouldRun(GameEntity gameEntity) {
    return false;
  }
}
