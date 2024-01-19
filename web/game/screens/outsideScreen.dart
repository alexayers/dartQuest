import '../../engine/application/gameScreen.dart';
import '../../engine/ecs/components/cameraComponent.dart';
import '../../engine/ecs/components/floorComponent.dart';
import '../../engine/ecs/components/rendering/spriteSheetComponent.dart';
import '../../engine/ecs/components/sound/hurtSoundComponent.dart';
import '../../engine/ecs/components/rendering/spriteComponent.dart';
import '../../engine/ecs/components/transparentComponent.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/components/wallComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/ecs/system/render/rayCastRenderSystem.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/rayCaster/camera.dart';
import '../../engine/rendering/rayCaster/worldMap.dart';
import '../../engine/rendering/sprite.dart';
import '../../engine/rendering/spriteSheet.dart';
import '../components/healthComponent.dart';
import '../items/flowers.dart';
import '../items/grave.dart';
import '../npc/dog.dart';
import '../systems/rendering/fogRenderSystem.dart';
import '../systems/rendering/rainRenderSystem.dart';
import 'gameScreenBase.dart';
import 'overlay/uiOverlayScreen.dart';

class OutsideScreen extends GameScreenBase implements GameScreen {
  @override
  void init() {
    renderSystems.add(RayCastRenderSystem());
    renderSystems.add(RainRenderSystem());
    renderSystems.add(FogRenderSystem());

    walkSound = "stepDirt";

    audioManager.register("stepDirt", "../../assets/sound/stepDirt.wav");
    audioManager.register("rain", "../../assets/sound/rain.ogg", true);

    camera = Camera(3, 3, -0.005, 0.9999, 0.66);

    player = GameEntityBuilder("player")
        .addComponent(createInventory())
        .addComponent(HurtSoundComponent(
            "playerHurt", "../../assets/sound/playerHurt.wav"))
        .addComponent(HealthComponent(100, 100))
        .addComponent(CameraComponent(camera))
        .addComponent(VelocityComponent(0, 0))
        .build();

    gameEntityRegistry.registerSingleton(player);

    gameScreenOverlays.add(UiOverlayScreen());

    for (var overlays in gameScreenOverlays) {
      overlays.init();
    }
  }

  void _createMap() {
    GameEntity floor =
        GameEntityBuilder("floor").addComponent(FloorComponent()).build();

    translationTable[0] = floor;

    SpriteSheet spriteSheet = SpriteSheet(SpriteSheetDefinition("../../assets/images/outside/tileSetOutside2.png",
        [
          "trees", "bush", "dirt", "berries", //
          "waterFall1", "waterFall2", "waterFall3", "waterFall4",
          "shopSign", "shopDoor", "shopWindow", "showWall",
          "stoneWall", "caveEntrance","transparentWall"
        ], 16, 16));

    GameEntity wall = GameEntityBuilder("wall")
        .addComponent(WallComponent())
    .addComponent(SpriteSheetComponent(spriteSheet, "trees"))
        .build();

    translationTable[1] = wall;


    GameEntity wall2 =
    GameEntityBuilder("wall2")
        .addComponent(TransparentComponent())
        .addComponent(SpriteComponent(Sprite(128, 128, "../../assets/images/outside/transparentWall.png")))
        .addComponent(WallComponent()).build();

    translationTable[2] = wall2;

    GameEntity stoneWall =
    GameEntityBuilder("stoneWall")
        .addComponent(SpriteSheetComponent(spriteSheet, "shopSign"))
        .addComponent(WallComponent()).build();


    translationTable[3] = stoneWall;


    List<int> grid = [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // no format
      1, 2, 2, 2, 2, 0, 2, 2, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 0, 2, 2, 2, 0, 0, 2, 1,
      1, 2, 0, 2, 3, 2, 0, 0, 2, 1,
      1, 2, 0, 2, 2, 2, 0, 0, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
      1, 1, 1, 3, 1, 1, 1, 1, 1, 1
    ];

    WorldDefinition worldDefinition = WorldDefinition();
    worldDefinition.skyColor = Color(16, 29, 52);
    worldDefinition.floorColor = Color(38, 90, 42);
    worldDefinition.lightRange = 8;
    worldDefinition.grid = grid;
    worldDefinition.items = addItems();
    worldDefinition.npcs = addNpcs();
    worldDefinition.width = 10;
    worldDefinition.height = 10;
    worldDefinition.skyBox = null;
    worldDefinition.translationTable = translationTable;

    worldMap.loadMap(worldDefinition);
  }

  List<GameEntity> addNpcs() {
    List<GameEntity> npcs = [];



    npcs.add(Dog.create());


  // npcs.add(Skeleton.create());

    return npcs;
  }

  List<GameEntity> addItems() {
    List<GameEntity> items = [];

    items.add(Flower.create());
    items.add(Grave.create());

    return items;
  }

  @override
  void onEnter() {
    audioManager.play("rain");

    _createMap();

    player.removeComponent("dead");
    player.addComponent(HealthComponent(100, 100));
  }

  @override
  void onExit() {
    audioManager.stop("rain");
  }
}
