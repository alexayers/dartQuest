import 'dart:math';

import '../../engine/application/globalState.dart';
import '../../engine/audio/audioManager.dart';
import '../../engine/ecs/components/animatedSpriteComponent.dart';
import '../../engine/ecs/components/damageComponent.dart';
import '../../engine/ecs/components/floorComponent.dart';
import '../../engine/ecs/components/holdingSpriteComponent.dart';
import '../../engine/ecs/components/interactions/attackActionComponent.dart';
import '../../engine/ecs/components/inventoryComponent.dart';
import '../../engine/ecs/components/inventorySpriteComponent.dart';
import '../../engine/ecs/components/velocityComponent.dart';
import '../../engine/ecs/gameEntity.dart';
import '../../engine/ecs/gameEntityBuilder.dart';
import '../../engine/ecs/gameEntityRegistry.dart';
import '../../engine/ecs/gameRenderSystem.dart';
import '../../engine/ecs/gameSystem.dart';
import '../../engine/ecs/system/entity/aiSystem.dart';
import '../../engine/ecs/system/entity/attackSystem.dart';
import '../../engine/ecs/system/entity/cameraSystem.dart';
import '../../engine/ecs/system/entity/damageSystem.dart';
import '../../engine/ecs/system/entity/interactionSystem.dart';
import '../../engine/ecs/system/entity/movementSystem.dart';
import '../../engine/ecs/system/entity/pickUpSystem.dart';
import '../../engine/ecs/system/render/rayCastRenderSystem.dart';
import '../../engine/input/keyboard.dart';
import '../../engine/input/mouse.dart';
import '../../engine/logger/logger.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/font.dart';
import '../../engine/rendering/rayCaster/camera.dart';
import '../../engine/rendering/rayCaster/renderPerformance.dart';
import '../../engine/rendering/rayCaster/worldMap.dart';
import '../../engine/rendering/renderer.dart';
import '../../engine/rendering/sprite.dart';
import '../../engine/utils/timerUtil.dart';
import '../../fonts.dart';


class GameScreenBase {
  late String walkSound ="";
  final num _moveSpeed = 0.065;

  final AudioManager audioManager = AudioManager.instance;
  final GameEntityRegistry gameEntityRegistry = GameEntityRegistry.instance;
  final List<GameSystem> gameSystems = [];
  final List<GameRenderSystem> renderSystems = [];
  final List<GameRenderSystem> postRenderSystems = [];
  final WorldMap worldMap = WorldMap.instance;
  late GameEntity player;
  late Camera camera;

  num _moveSway = 0;
  bool _updateSway = false;
  late num _lastXPos = 0;
  late num _lastYPos = 0;
  int _moves = 0;
  List<GameEntity> requiresPower = [];
  bool _useTool = false;
  final Map<int, GameEntity> translationTable = {};
  final TimerUtil _walkTimer = TimerUtil(550);
  final TimerUtil _attackTimer = TimerUtil(250);

  GameScreenBase() {

    registerSystems([
      CameraSystem(),
      InteractionSystem(),
      PickUpSystem(),
      DamageSystem(),
      AttackSystem(),
      AiSystem(),
      MovementSystem()
    ]);


    logger(LogType.info, "Systems registered");
  }

  void sway() {
    if (!_updateSway) {
      num sway = _moveSway % (pi * 2);
      num diff = 0;

      if (sway - pi <= 0) {
        diff = -pi / 30;
      } else {
        diff = pi / 30;
      }

      if (sway + diff < 0 || sway + diff > pi * 2) {
        _moveSway -= sway;
      } else {
        _moveSway += diff;
      }
      return;
    }

    if (_moves > 1) {
      _moveSway += pi / 25;
      _moveSway %= pi * 8;
    }
  }

  void keyboard() {
    num moveSpeed = _moveSpeed * RenderPerformance.deltaTime;
    num moveX = 0;
    num moveY = 0;

    InventoryComponent inventory =
        player.getComponent("inventory") as InventoryComponent;

    VelocityComponent velocity =
        player.getComponent("velocity") as VelocityComponent;

    if (isKeyDown(keyboardInput.one)) {
      inventory.currentItemIdx = 0;
    }

    if (isKeyDown(keyboardInput.two)) {
      inventory.currentItemIdx = 1;
    }

    if (isKeyDown(keyboardInput.three)) {
      inventory.currentItemIdx = 2;
    }

    if (isKeyDown(keyboardInput.four)) {
      inventory.currentItemIdx = 3;
    }

    if (isKeyDown(keyboardInput.five)) {
      inventory.currentItemIdx = 4;
    }

    if (isKeyDown(keyboardInput.six)) {
      inventory.currentItemIdx = 5;
    }

    if (isKeyDown(keyboardInput.up)) {
      moveX += camera.xDir;
      moveY += camera.yDir;
      _updateSway = true;
      _moves++;

      if (_walkTimer.hasTimePassed()) {
        _walkTimer.reset();
        if (walkSound != "") {
          audioManager.play(walkSound);
        }
      }
    }

    if (isKeyDown(keyboardInput.down)) {
      moveX -= camera.xDir;
      moveY -= camera.yDir;
      _updateSway = true;
      _moves++;

      if (_walkTimer.hasTimePassed()) {
        _walkTimer.reset();

        if (walkSound != "") {
          audioManager.play(walkSound);
        }

      }
    }

    if (isKeyDown(keyboardInput.left)) {
      velocity.rotateLeft = true;
    }

    if (isKeyDown(keyboardInput.right)) {
      velocity.rotateRight = true;
    }

    if (isKeyDown(keyboardInput.space)) {
      InventoryComponent inventory =
          player.getComponent("inventory") as InventoryComponent;
      GameEntity holdingItem = inventory.getCurrentItem()!;

      if (_attackTimer.hasTimePassed()) {

        _attackTimer.reset();

        if (holdingItem.hasComponent("damage")) {
          player.addComponent(AttackActionComponent());
        }

        _useTool = true;
      }

    }

    if (isKeyDown(keyboardInput.shift)) {
      moveX *= moveSpeed * 2;
      moveY *= moveSpeed * 2;
    } else {
      moveX *= moveSpeed;
      moveY *= moveSpeed;
    }

    velocity.velX = moveX;
    velocity.velY = moveY;

    _lastXPos = camera.xPos;
    _lastYPos = camera.yPos;
  }

  void logicLoop() {
    keyboard();

    List<GameEntity> gameEntities = [];
    gameEntities.add(player);
    gameEntities.addAll(worldMap.getWorldNpcs());

    for (var gameEntity in gameEntities) {
      for (var gameSystem in gameSystems) {
        if (gameSystem.shouldRun(gameEntity)) {
          gameSystem.processEntity(gameEntity);
          gameSystem.removeIfPresent(gameEntity);
        }
      }
    }


    if (camera.xPos == _lastXPos && camera.yPos == _lastYPos) {
      _updateSway = false;
      _moves = 0;
    }
  }

  InventoryComponent createInventory() {
    InventoryComponent inventory = InventoryComponent(6);


    GameEntity sword = GameEntityBuilder("sword")
        .addComponent(DamageComponent(1))
        .addComponent(InventorySpriteComponent(
            Sprite(0, 0, "../../assets/images/weapons/swordInventory.png")))
        .addComponent(HoldingSpriteComponent(
            Sprite(0, 0, "../../assets/images/weapons/sword.png")))
        .build();

    inventory.addItem(sword);



    return inventory;
  }

  void holdingItem() {
    InventoryComponent inventory =
        player.getComponent("inventory") as InventoryComponent;
    GameEntity? holdingItem = inventory.getCurrentItem();

    if (holdingItem != null) {
      double xOffset = sin(_moveSway / 2) * 40;
      double yOffset = cos(_moveSway) * 30;

      HoldingSpriteComponent holdingItemSprite =
          holdingItem.getComponent("holdingSprite") as HoldingSpriteComponent;
      holdingItemSprite.sprite.render(480 + xOffset, 400 + yOffset, 256, 256);
    }
  }

  void addEntity(int id, GameEntity gameEntity) {
    translationTable[id] = gameEntity;
    gameEntityRegistry.register(gameEntity);
  }

  void wideScreen() {
    Renderer.rect(0, 0, Renderer.getCanvasWidth(), 40, Colors.black);

    Renderer.rect(0, Renderer.getCanvasHeight() - 40, Renderer.getCanvasWidth(),
        40, Colors.black);

    int offsetX = 550;
    int offsetY = 50;

    InventoryComponent inventory =
        player.getComponent("inventory") as InventoryComponent;
    int inventoryBoxSize = 32;

    for (int i = 0; i < inventory.maxItems; i++) {
      if (i == inventory.currentItemIdx) {
        Renderer.rect(offsetX - 1, Renderer.getCanvasHeight() - (offsetY + 1),
            inventoryBoxSize + 2, inventoryBoxSize + 2, Colors.white);
      } else {
        Renderer.rect(offsetX - 1, Renderer.getCanvasHeight() - (offsetY + 1),
            inventoryBoxSize + 2, inventoryBoxSize + 2, Colors.white);
      }

      Renderer.rect(offsetX, Renderer.getCanvasHeight() - offsetY,
          inventoryBoxSize, inventoryBoxSize, Color(190, 190, 190, 0.45));

      if (inventory.inventory[i] != null) {
        InventorySpriteComponent inventorySprite = inventory.inventory[i]!
            .getComponent("inventorySprite") as InventorySpriteComponent;
        Renderer.renderImage(
            inventorySprite.sprite.image,
            offsetX,
            Renderer.getCanvasHeight() - offsetY,
            inventoryBoxSize - 4,
            inventoryBoxSize - 4);
      }

      offsetX += inventoryBoxSize + 6;
    }
  }

  void debug() {
    Renderer.print("X: ${camera.xPos} Y: ${camera.yPos}", 10, 20,
        Font(Fonts.oxanium.name, 10, Colors.white));
    Renderer.print("dirX: ${camera.xDir} dirY: ${camera.yDir}", 10, 40,
        Font(Fonts.oxanium.name, 10, Colors.white));
  }

  void registerSystems(List<GameSystem> systems) {
    for (var system in systems) {
      gameSystems.add(system);
    }
  }

  void registerRenderSystems(List<GameRenderSystem> gameRenderSystems) {
    for (var gameRenderSystem in gameRenderSystems) {
      renderSystems.add(gameRenderSystem);
    }
  }

  void registerPostRenderSystems(List<GameRenderSystem> gameRenderSystems) {
    for (var gameRenderSystem in gameRenderSystems) {
      postRenderSystems.add(gameRenderSystem);
    }
  }



  @override
  void mouseClick(double x, double y, MouseButton mouseButton) {
    // TODO: implement mouseClick
  }

  @override
  void mouseMove(double x, double y) {
    // TODO: implement mouseMove
  }
}
