import 'components/distanceComponent.dart';
import 'gameComponent.dart';
import 'gameEntity.dart';

class GameEntityBuilder {
  final GameEntity _gameEntity;

  GameEntityBuilder(String name) : _gameEntity = GameEntity(name) {
    _gameEntity.addComponent(DistanceComponent());
  }




  GameEntityBuilder addComponent(GameComponent gameComponent) {
    _gameEntity.addComponent(gameComponent);
    return this;
  }

  GameEntity build() {
    return _gameEntity;
  }
}
