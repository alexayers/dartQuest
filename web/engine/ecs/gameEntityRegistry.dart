import 'components/distanceComponent.dart';
import 'gameEntity.dart';

class GameEntityRegistry {
  static GameEntityRegistry? _instance;
  final List<GameEntity> _entities = [];
  final Map<String, GameEntity> _singletonEntities = {};

  GameEntityRegistry._privateConstructor();

  static GameEntityRegistry get instance {
    _instance ??= GameEntityRegistry._privateConstructor();
    return _instance!;
  }

  void register(GameEntity gameEntity) {
    gameEntity.addComponent(DistanceComponent(1));
    _entities.add(gameEntity);
  }

  void registerSingleton(GameEntity gameEntity) {
    _singletonEntities[gameEntity.name] = gameEntity;
  }

  GameEntity getSingleton(String name) {
    return _singletonEntities[name]!;
  }

  List<GameEntity> getEntities() {
    return _entities;
  }
}
