import '../../ecs/components/doorComponent.dart';
import '../../ecs/components/pushWallComponent.dart';
import '../../ecs/gameEntity.dart';
import '../../logger/logger.dart';
import '../../primitives/color.dart';
import '../sprite.dart';
import 'renderPerformance.dart';

enum DoorState { closed, opening, open, closing }

class WorldDefinition {
  late List<int> grid;
  late List<GameEntity> items = [];
  late List<GameEntity> npcs = [];
  late Sprite? skyBox;
  late Color skyColor;
  late Color floorColor;
  late Map<int, GameEntity> translationTable;
  late num lightRange;
  late int width;
  late int height;
}

class WorldMap {
  static WorldMap? _instance;
  late List<GameEntity> _gameMap = [];
  late int _worldWidth;
  late int _worldHeight;
  List<num> _doorOffsets = [];
  List<DoorState> _doorStates = [];
  late WorldDefinition worldDefinition;
  bool _worldLoaded = false;

  WorldMap._privateConstructor();

  static WorldMap get instance {
    _instance ??= WorldMap._privateConstructor();
    return _instance!;
  }

  void loadMap(WorldDefinition worldDefinition) {
    this.worldDefinition = worldDefinition;
    _worldWidth = worldDefinition.width;
    _worldHeight = worldDefinition.height;

    for (int y = 0; y < _worldHeight; y++) {
      for (int x = 0; x < _worldWidth; x++) {
        int pos = x + (y * _worldWidth);
        int value = worldDefinition.grid[pos];
        _gameMap.add(worldDefinition.translationTable[value]!);
      }
    }

    for (int i = 0; i < _worldWidth * _worldHeight; i++) {
      _doorOffsets.add(0);
      _doorStates.add(DoorState.closed);
    }

    _worldLoaded = true;
    logger(LogType.info, "The map has been loaded.");
  }

  void moveDoors() {
    if (!_worldLoaded) {
      return;
    }

    for (int y = 0; y < _worldHeight; y++) {
      for (int x = 0; x < _worldWidth; x++) {
        GameEntity gameEntity = getEntityAtPosition(x, y);

        if (gameEntity.hasComponent("door")) {
          //Standard door
          if (getDoorState(x, y) == DoorState.opening) {
            //Open doors
            setDoorOffset(
                x, y, getDoorOffset(x, y) + RenderPerformance.deltaTime / 100);

            if (getDoorOffset(x, y) > 1) {
              setDoorOffset(x, y, 1);
              setDoorState(x, y, DoorState.open); //Set state to open

              DoorComponent door =
                  gameEntity.getComponent("door") as DoorComponent;
              door.openDoor();

              Future.delayed(Duration(seconds: 5), () {
                setDoorState(x, y, DoorState.closing);

                var door = gameEntity.getComponent("door") as DoorComponent;
                door.closeDoor();
              });
            }
          } else if (getDoorState(x, y) == DoorState.closing) {
            setDoorOffset(
                x, y, getDoorOffset(x, y) - RenderPerformance.deltaTime / 100);

            if (getDoorOffset(x, y) < 0) {
              setDoorOffset(x, y, 0);
              setDoorState(x, y, DoorState.closed);

              DoorComponent door =
                  gameEntity.getComponent("door") as DoorComponent;
              door.closeDoor();
            }
          }
        } else if (gameEntity.hasComponent("pushWall")) {
          if (getDoorState(x, y) == DoorState.opening) {
            setDoorOffset(
                x, y, getDoorOffset(x, y) + RenderPerformance.deltaTime / 100);

            if (getDoorOffset(x, y) > 2) {
              setDoorOffset(x, y, 2);
              setDoorState(x, y, DoorState.open);

              PushWallComponent pushWall =
                  gameEntity.getComponent("pushWall") as PushWallComponent;
              pushWall.openWall();
            }
          }
        }
      }
    }
  }

  List<GameEntity> getWorldItems() {
    return worldDefinition.items;
  }

  List<GameEntity> getWorldNpcs() {
    return worldDefinition.npcs;
  }



  void removeWorldItem(GameEntity gameEntity) {

    int index = -1;
    for (int i = 0; i < worldDefinition.items.length; i++) {
      if (gameEntity.id == worldDefinition.items[i].id) {
        index = i;
      }
    }

    if (index > -1) {
      worldDefinition.items.removeAt(index);
    }


  }

  void removeWorldNpc(GameEntity gameEntity) {

    int index = -1;
    for (int i = 0; i < worldDefinition.npcs.length; i++) {
      if (gameEntity.id == worldDefinition.npcs[i].id) {
        index = i;
      }
    }

    if (index > -1) {
      worldDefinition.npcs.removeAt(index);
    }


  }

  GameEntity getEntityAtPosition(int x, int y) {
    return _gameMap[x + (y * _worldWidth)];
  }

  DoorState getDoorState(int x, int y) {
    return _doorStates[x + (y * _worldWidth)];
  }

  num getDoorOffset(int x, int y) {
    return _doorOffsets[x + (y * _worldWidth)];
  }

  void setDoorState(int x, int y, DoorState state) {
    _doorStates[x + (y * _worldWidth)] = state;
  }

  void setDoorOffset(int x, int y, num offset) {
    _doorOffsets[x + (y * _worldWidth)] = offset;
  }

  List<GameEntity> get gameMap => _gameMap;


}
