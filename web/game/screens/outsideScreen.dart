
import '../../engine/application/gameScreen.dart';
import '../../engine/ecs/components/SpriteSheetComponent.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/cameraComponent.dart';
import '../../engine/ecs/components/floorComponent.dart';
import '../../engine/ecs/components/spriteComponent.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/components/wallComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/ecs/system/render/rayCastRenderSystem.dart';
import '../../engine/logger/logger.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/rayCaster/camera.dart';
import '../../engine/rendering/rayCaster/worldMap.dart';
import '../../engine/rendering/sprite.dart';
import '../../engine/rendering/spriteSheet.dart';
import 'gameScreenBase.dart';

class OutsideScreen extends GameScreenBase implements GameScreen {

  @override
  void init() {
    renderSystems.add(RayCastRenderSystem());

    _createMap();

    camera = Camera(4.78, 1.988, -0.005, 0.9999, 0.66);

    player = GameEntityBuilder("player")
        .addComponent(createInventory())
        .addComponent(CameraComponent(camera))
        .addComponent(VelocityComponent(0, 0))
        .build();

    gameEntityRegistry.registerSingleton(player);

  }

  void _createMap() {

    GameEntity floor =
    GameEntityBuilder("floor").addComponent(FloorComponent()).build();

    translationTable[0] = floor;

    GameEntity wall = GameEntityBuilder("wall")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/trees.png")))
        .build();

    translationTable[1] = wall;


    GameEntity caveEntrance = GameEntityBuilder("caveEntrance")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/caveEntrance.png")))
        .build();

    translationTable[2] = caveEntrance;

    GameEntity stoneEntrance = GameEntityBuilder("stoneEntrance")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/stoneEntrance.png")))
        .build();

    translationTable[3] = stoneEntrance;

    GameEntity berries = GameEntityBuilder("berries")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/berries.png")))
        .build();

    translationTable[4] = berries;

    GameEntity dirt = GameEntityBuilder("dirt")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/dirt.png")))
        .build();

    translationTable[5] = dirt;

    GameEntity waterFall = GameEntityBuilder("waterFall")
        .addComponent(WallComponent())
        .addComponent(AnimatedSpriteComponent(128,128, [
          "../../assets/images/outside/waterFall1.png",
      "../../assets/images/outside/waterFall2.png",
      "../../assets/images/outside/waterFall3.png",
      "../../assets/images/outside/waterFall4.png",
    ]))
        .build();

    translationTable[6] = waterFall;

    GameEntity shopWall = GameEntityBuilder("shopWall")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/shopWall.png")))
        .build();

    translationTable[7] = shopWall;

    GameEntity shopDoor = GameEntityBuilder("shopDoor")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/shopDoor.png")))
        .build();

    translationTable[8] = shopDoor;

    GameEntity shopWindow = GameEntityBuilder("shopWindow")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/shopWindow.png")))
        .build();

    translationTable[9] = shopWindow;

    GameEntity shopSign = GameEntityBuilder("shopSign")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(Sprite(128,128, "../../assets/images/outside/shopSign.png")))
        .build();

    translationTable[10] = shopSign;


    List<int> grid = [
      1,1,1,1,1,1,1,1,1,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,0,4,0,0,0,0,0,0,1,
      3,0,0,0,0,0,10,8,9,1,
      2,0,0,0,0,0,9,0,0,1,
      3,0,4,0,0,0,7,7,7,1,
      1,0,0,0,0,0,0,4,0,1,
      1,0,0,0,0,0,0,0,0,1,
      1,1,1,1,5,6,5,1,1,1,
    ];

    WorldDefinition worldDefinition = WorldDefinition();
    worldDefinition.skyColor = Color(45, 178, 250);
    worldDefinition.floorColor = Color(38, 90, 42);
    worldDefinition.lightRange = 20;
    worldDefinition.grid = grid;
    worldDefinition.items = [];
    worldDefinition.npcs = [];
    worldDefinition.width = 10;
    worldDefinition.height = 10;
    worldDefinition.skyBox = null;
    worldDefinition.translationTable = translationTable;

    worldMap.loadMap(worldDefinition);

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
    debug();

  }

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }

}
