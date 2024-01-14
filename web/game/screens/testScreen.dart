import '../../engine/application/gameScreen.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/cameraComponent.dart';
import '../../engine/ecs/components/distanceComponent.dart';
import '../../engine/ecs/components/doorComponent.dart';
import '../../engine/ecs/components/floorComponent.dart';
import '../../engine/ecs/components/interactionComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/components/spriteComponent.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/components/wallComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/ecs/gameEntityRegistry.dart';
import '../../engine/ecs/gameRenderSystem.dart';
import '../../engine/ecs/gameSystem.dart';
import '../../engine/ecs/system/entity/cameraSystem.dart';
import '../../engine/ecs/system/entity/damageSystem.dart';
import '../../engine/ecs/system/entity/interactionSystem.dart';
import '../../engine/ecs/system/render/rayCastRenderSystem.dart';
import '../../engine/input/keyboard.dart';
import '../../engine/input/mouse.dart';
import '../../engine/logger/logger.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/rayCaster/camera.dart';
import '../../engine/rendering/rayCaster/renderPerformance.dart';
import '../../engine/rendering/rayCaster/worldMap.dart';
import '../../engine/rendering/sprite.dart';
import '../components/healthComponent.dart';
import 'gameScreenBase.dart';

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
        AnimatedSpriteComponent animatedSprite = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSprite.nextFrame();
      }
    }


    for (var gameEntity in worldMap.worldDefinition.items) {
      if (gameEntity.hasComponent("animatedSprite")) {
        AnimatedSpriteComponent animatedSprite = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSprite.nextFrame();
      }
    }

    for (var gameEntity in worldMap.worldDefinition.npcs) {
      if (gameEntity.hasComponent("animatedSprite")) {
        AnimatedSpriteComponent animatedSprite = gameEntity
            .getComponent("animatedSprite") as AnimatedSpriteComponent;
        animatedSprite.nextFrame();
      }
    }


    sway();
    holdingItem();

    wideScreen();

  }
}
