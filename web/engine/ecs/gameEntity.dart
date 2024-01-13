import 'package:uuid/uuid.dart';

import 'gameComponent.dart';

class GameEntity {
  final String _id;
  final String _name;
  final Map<String, GameComponent> _gameComponents = {};

  GameEntity(String name)
      : _id = Uuid().v4(),
        _name = name;

  void addComponent(GameComponent gameComponent) {
    _gameComponents[gameComponent.name] = gameComponent;
  }

  GameComponent? getComponent(String name) {
    return _gameComponents[name];
  }

  void removeComponent(String name) {
    _gameComponents.remove(name);
  }

  bool hasComponent(String name) {
    return _gameComponents.containsKey(name);
  }

  Map<String, GameComponent> get gameComponents => _gameComponents;

  String get name => _name;

  String get id => _id;
}
