import '../../engine/application/gameScreen.dart';
import '../../engine/ecs/components/ai/aiComponent.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/cameraComponent.dart';
import '../../engine/ecs/components/distanceComponent.dart';
import '../../engine/ecs/components/doorComponent.dart';
import '../../engine/ecs/components/floorComponent.dart';
import '../../engine/ecs/components/itemComponent.dart';
import '../../engine/ecs/components/positionComponent.dart';
import '../../engine/ecs/components/sound/hurtSoundComponent.dart';
import '../../engine/ecs/components/sound/timedSoundComponent.dart';
import '../../engine/ecs/components/spriteComponent.dart';
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
import '../components/healthComponent.dart';
import '../npc/skeleton.dart';
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

    GameEntity wall = GameEntityBuilder("wall")
        .addComponent(WallComponent())
        .addComponent(SpriteComponent(
            Sprite(128, 128, "../../assets/images/outside/trees.png")))
        .build();

    translationTable[1] = wall;

    GameEntity wall2 =
    GameEntityBuilder("wall2")
        .addComponent(TransparentComponent())
        .addComponent(SpriteComponent(
        Sprite(128, 128, "../../assets/images/outside/transparentWall.png")))
        .addComponent(WallComponent()).build();

    translationTable[2] = wall2;

    GameEntity well =
    GameEntityBuilder("well")
        .addComponent(SpriteComponent(
        Sprite(128, 128, "../../assets/images/outside/well1.png")))
        .addComponent(WallComponent()).build();


    translationTable[3] = well;


    List<int> grid = [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // no format
      1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 0, 2, 2, 2, 0, 0, 2, 1,
      1, 2, 0, 2, 3, 2, 0, 0, 2, 1,
      1, 2, 0, 2, 2, 2, 0, 0, 2, 1,
      1, 2, 0, 0, 0, 0, 0, 0, 2, 1,
      1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1
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

    Map<String, List<String>> dogAnimation = {};

    dogAnimation["walking"] = [
      "../../assets/images/npc/dog/dog1.png",
      "../../assets/images/npc/dog/dog2.png",
      "../../assets/images/npc/dog/dog1.png",
      "../../assets/images/npc/dog/dog3.png"
    ];

    dogAnimation["default"] = [
      "../../assets/images/npc/dog/dogSit1.png",
      "../../assets/images/npc/dog/dogSit2.png",
      "../../assets/images/npc/dog/dogSit1.png",
      "../../assets/images/npc/dog/dogSit3.png"
    ];

    GameEntity dog = GameEntityBuilder("dog")
        .addComponent(DistanceComponent())
        .addComponent(VelocityComponent(0, 0))
        .addComponent(
            TimedSoundComponent("bark", "../../assets/sound/bark.wav", 2000))
        .addComponent(AiComponent(MovementStyle.wander, true))
        .addComponent(PositionComponent(3, 3))
        .addComponent(AnimatedSpriteComponent(32, 32, dogAnimation))
        .build();

    npcs.add(dog);


  //  npcs.add(Skeleton.create());

    return npcs;
  }

  List<GameEntity> addItems() {
    List<GameEntity> items = [];

    Map<String, List<String>> flowerImages = {};
    flowerImages["default"] = ["../../assets/images/outside/flowers.png"];

    GameEntity flowers = GameEntityBuilder("flowers")
        .addComponent(ItemComponent())
        .addComponent(PositionComponent(3.4, 4.9))
        .addComponent(AnimatedSpriteComponent(15, 15, flowerImages))
        .build();

    items.add(flowers);

    GameEntity flowers2 = GameEntityBuilder("flowers")
        .addComponent(ItemComponent())
        .addComponent(PositionComponent(5.3, 4.2))
        .addComponent(AnimatedSpriteComponent(15, 15, flowerImages))
        .build();

    items.add(flowers2);

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
