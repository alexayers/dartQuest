import 'game_entity.dart';

abstract class GameSystem {
  void processEntity(GameEntity gameEntity);

  bool shouldRun(GameEntity gameEntity);

  void removeIfPresent(GameEntity gameEntity);
}
