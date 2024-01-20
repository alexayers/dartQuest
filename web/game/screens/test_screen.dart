import '../../engine/application/game_screen.dart';
import '../../engine/ecs/components/rendering/animated_sprite_component.dart';
import '../../engine/ecs/components/camera_component.dart';
import '../../engine/ecs/components/door_component.dart';
import '../../engine/ecs/components/floor_component.dart';
import '../../engine/ecs/components/rendering/sprite_component.dart';
import '../../engine/ecs/components/velocity_component.dart';
import '../../engine/ecs/components/wall_component.dart';
import '../../engine/ecs/game_entity.dart';
import '../../engine/ecs/game_entity_builder.dart';
import '../../engine/ecs/system/entity/camera_system.dart';
import '../../engine/ecs/system/entity/damage_system.dart';
import '../../engine/ecs/system/entity/interaction_system.dart';
import '../../engine/ecs/system/render/raycast_render_system.dart';
import '../../engine/input/mouse.dart';
import '../../engine/logger/logger.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/rayCaster/camera.dart';
import '../../engine/rendering/rayCaster/world_map.dart';
import '../../engine/rendering/sprite.dart';
import 'game_screen_base.dart';

class TestScreen extends GameScreenBase implements GameScreen {


  @override
  void init() {

    walkSound = "stepDirt.wav";
    gameSystems.add(CameraSystem());
    gameSystems.add(InteractionSystem());
    gameSystems.add(DamageSystem());


    renderSystems.add(RayCastRenderSystem());

    GameEntity wall = GameEntityBuilder("wall")
        .addComponent(WallComponent())
        .addComponent(
            SpriteComponent(Sprite(128, 128, "../../assets/images/stoneWall.png")))
        .build();

    GameEntity floor =
        GameEntityBuilder("floor").addComponent(FloorComponent()).build();

    GameEntity door = GameEntityBuilder("door")
        .addComponent(DoorComponent())
        .addComponent(
            SpriteComponent(Sprite(128, 128, "../../assets/images/door.png")))
        .build();

    GameEntity doorFrame = GameEntityBuilder("doorFrame")
        .addComponent(WallComponent())
        .addComponent(
            SpriteComponent(Sprite(128, 128, "../../assets/images/doorFrame.png")))
        .build();

    gameEntityRegistry.registerSingleton(doorFrame);



    List<int> grid = [
      1,1,1,1,1,1,1,1,1,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,1,1,1,1,1,1,1,1,1,
    ];

    Map<int, GameEntity> translationTable = {};

    translationTable[0] = floor;
    translationTable[1] = wall;
    translationTable[3] = door;

    WorldDefinition worldDefinition = WorldDefinition();
    worldDefinition.skyColor = Color(45, 178, 250);
    worldDefinition.floorColor = Color(25, 25, 25);
    worldDefinition.lightRange = 7;
    worldDefinition.grid = grid;
    worldDefinition.items = [];
    worldDefinition.npcs = [];
    worldDefinition.width = 10;
    worldDefinition.height = 10;
    worldDefinition.skyBox = null;
    worldDefinition.translationTable = translationTable;

    worldMap.loadMap(worldDefinition);


    camera = Camera(2, 2, 0, 1, 0.66);

    player = GameEntityBuilder("player")
        .addComponent(createInventory())
        .addComponent(CameraComponent(camera))
        .addComponent(VelocityComponent(0, 0))
        .build();

    gameEntityRegistry.registerSingleton(player);
  }

  @override
  void mouseClick(double x, double y, MouseButton mouseButton) {
    logger(LogType.debug, "mouseClick");
  }

  @override
  void mouseMove(double x, double y) {
    logger(LogType.debug, "mouseMove");
  }

  @override
  void onEnter() {
    logger(LogType.debug, "onEnter");
  }

  @override
  void onExit() {
    logger(LogType.debug, "onExit");
  }

  @override
  void renderLoop() {
    for (var system in renderSystems) {
      system.process();
    }

    for (var gameEntity in translationTable.values) {
      if (gameEntity.hasComponent("animatedSprite")) {
        AnimatedSpriteComponent animatedSpriteComponent = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSpriteComponent.animatedSprite.nextFrame();
      }
    }


    for (var gameEntity in worldMap.worldDefinition.items) {
      if (gameEntity.hasComponent("animatedSprite")) {
        AnimatedSpriteComponent animatedSpriteComponent = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSpriteComponent.animatedSprite.nextFrame();
      }
    }

    for (var gameEntity in worldMap.worldDefinition.npcs) {
      if (gameEntity.hasComponent("animatedSprite")) {
        AnimatedSpriteComponent animatedSpriteComponent = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSpriteComponent.animatedSprite.nextFrame();
      }
    }


    sway();
    holdingItem();

    wideScreen();

  }
}
