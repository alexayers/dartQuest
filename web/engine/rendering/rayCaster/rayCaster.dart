import 'dart:math' as math;
import 'dart:math';

import '../../../game/systems/rendering/cloudRenderSystem.dart';
import '../../ecs/components/animatedSpriteComponent.dart';
import '../../ecs/components/cameraComponent.dart';
import '../../ecs/components/distanceComponent.dart';
import '../../ecs/components/positionComponent.dart';
import '../../ecs/components/spriteComponent.dart';
import '../../ecs/gameEntity.dart';
import '../../ecs/gameEntityRegistry.dart';
import '../../primitives/color.dart';
import '../renderer.dart';
import '../sprite.dart';
import 'camera.dart';
import 'transparentWall.dart';
import 'worldMap.dart';

class RayCaster {
  final List<num> _cameraXCoords = [];
  final List<num> _zBuffer = List.filled(1024, 0.0);
  final List<TransparentWall> _transparentWalls = [];
  final WorldMap worldMap = WorldMap.instance;
  final GameEntityRegistry _gameEntityRegistry = GameEntityRegistry.instance;
  final CloudRenderSystem cloudRenderSystem = CloudRenderSystem();

  RayCaster() {
    for (int x = 0; x < Renderer.getCanvasWidth(); x++) {
      double cameraX = 2 * x / Renderer.getCanvasWidth() - 1;
      _cameraXCoords.add(cameraX);
    }
  }

  void drawWall(Camera camera, int x) {
    WorldMap worldMap = WorldMap.instance;
    num rayDirX = camera.xDir + camera.xPlane * _cameraXCoords[x];
    num rayDirY = camera.yDir + camera.yPlane * _cameraXCoords[x];
    int mapX = camera.xPos.floor();
    int mapY = camera.yPos.floor();
    num sideDistX;
    num sideDistY;
    num deltaDistX = (1 / rayDirX).abs();
    num deltaDistY = (1 / rayDirY).abs();
    num perpWallDist = 0;
    int stepX;
    int stepY;
    int hit = 0;
    int side = 0;
    num wallXOffset = 0;
    num wallYOffset = 0;
    num wallX = 0;
    int rayTex = 0;
    GameEntity? gameEntity;

    if (rayDirX < 0) {
      stepX = -1;
      sideDistX = (camera.xPos - mapX) * deltaDistX;
    } else {
      stepX = 1;
      sideDistX = (mapX + 1.0 - camera.xPos) * deltaDistX;
    }

    if (rayDirY < 0) {
      stepY = -1;
      sideDistY = (camera.yPos - mapY) * deltaDistY;
    } else {
      stepY = 1;
      sideDistY = (mapY + 1.0 - camera.yPos) * deltaDistY;
    }

    while (hit == 0) {
      if (sideDistX < sideDistY) {
        sideDistX += deltaDistX;
        mapX += stepX;
        side = 0;
      } else {
        sideDistY += deltaDistY;
        mapY += stepY;
        side = 1;
      }

      gameEntity = worldMap.getEntityAtPosition(mapX, mapY);

      if (!gameEntity.hasComponent("floor")) {
        if (gameEntity.hasComponent("door") &&
            worldMap.getDoorState(mapX, mapY) != DoorState.open) {
          hit = 1;
          if (side == 1) {
            wallYOffset = 0.5 * stepY;
            perpWallDist =
                (mapY - camera.yPos + wallYOffset + (1 - stepY) / 2) / rayDirY;
            wallX = camera.xPos + perpWallDist * rayDirX;
            wallX -= wallX.floor();
            if (sideDistY - (deltaDistY / 2) < sideDistX) {
              if (1.0 - wallX <= worldMap.getDoorOffset(mapX, mapY)) {
                hit = 0;
                wallYOffset = 0;
              }
            } else {
              mapX += stepX;
              side = 0;
              rayTex = 4;
              wallYOffset = 0;
            }
          } else {
            wallXOffset = 0.5 * stepX;
            perpWallDist =
                (mapX - camera.xPos + wallXOffset + (1 - stepX) / 2) / rayDirX;
            wallX = camera.yPos + perpWallDist * rayDirY;
            wallX -= wallX.floor();
            if (sideDistX - (deltaDistX / 2) < sideDistY) {
              if (1.0 - wallX < worldMap.getDoorOffset(mapX, mapY)) {
                hit = 0;
                wallXOffset = 0;
              }
            } else {
              mapY += stepY;
              side = 1;
              rayTex = 4;
              wallXOffset = 0;
            }
          }
        } else if (gameEntity.hasComponent("pushWall") &&
            worldMap.getDoorState(mapX, mapY) != DoorState.open) {
          if (side == 1 &&
              sideDistY -
                      (deltaDistY * (1 - worldMap.getDoorOffset(mapX, mapY))) <
                  sideDistX) {
            hit = 1;
            wallYOffset = worldMap.getDoorOffset(mapX, mapY) * stepY;
          } else if (side == 0 &&
              sideDistX -
                      (deltaDistX * (1 - worldMap.getDoorOffset(mapX, mapY))) <
                  sideDistY) {
            hit = 1;
            wallXOffset = worldMap.getDoorOffset(mapX, mapY) * stepX;
          }
        } else if (gameEntity.hasComponent("transparent")) {
          if (side == 1) {
            if (sideDistY - (deltaDistY / 2) < sideDistX) {
              bool wallDefined = false;
              for (int i = 0; i < _transparentWalls.length; i++) {
                if (_transparentWalls[i].xMap == mapX &&
                    _transparentWalls[i].yMap == mapY) {
                  _transparentWalls[i].cameraXCoords.add(x);
                  wallDefined = true;
                  break;
                }
              }
              if (!wallDefined) {
                SpriteComponent sprite =
                    gameEntity.getComponent("sprite") as SpriteComponent;
                TransparentWall transparentWall = TransparentWall(
                    sprite.sprite, camera, mapX, mapY, side, x, _cameraXCoords);
                _transparentWalls.add(transparentWall);
              }
            }
          } else {
            if (sideDistX - (deltaDistX / 2) < sideDistY) {
              bool wallDefined = false;
              for (int i = 0; i < _transparentWalls.length; i++) {
                if (_transparentWalls[i].xMap == mapX &&
                    _transparentWalls[i].yMap == mapY) {
                  _transparentWalls[i].cameraXCoords.add(x);
                  wallDefined = true;
                  break;
                }
              }
              if (!wallDefined) {
                SpriteComponent sprite =
                    gameEntity.getComponent("sprite") as SpriteComponent;
                TransparentWall transparentWall = TransparentWall(
                    sprite.sprite, camera, mapX, mapY, side, x, _cameraXCoords);
                _transparentWalls.add(transparentWall);
              }
            }
          }
        } else if (!gameEntity.hasComponent("door") &&
            !gameEntity.hasComponent("pushWall")) {
          GameEntity adjacentGameEntityUp =
              worldMap.getEntityAtPosition(mapX, mapY - stepY);
          GameEntity adjacentGameEntityAcross =
              worldMap.getEntityAtPosition(mapX - stepX, mapY);

          if (side == 1 && adjacentGameEntityUp.hasComponent("door")) {
            rayTex = 4;
          } else if (side == 0 &&
              adjacentGameEntityAcross.hasComponent("door")) {
            rayTex = 4;
          }

          hit = 1;
        }
      }
    }

    perpWallDist = calculatePerpWall(side, mapX, mapY, camera, wallXOffset,
        wallYOffset, stepX, stepY, rayDirX, rayDirY);

    _zBuffer[x] = perpWallDist;

    int lineHeight = (Renderer.getCanvasHeight() / perpWallDist).round();
    double drawStart =
        -lineHeight / 2 + (Renderer.getCanvasHeight() / 2).round();

    if (side == 0) {
      wallX = camera.yPos + perpWallDist * rayDirY;
    } else if (side == 1 || side == 2) {
      wallX = camera.xPos + perpWallDist * rayDirX;
    }

    wallX -= wallX.floor();

    if (gameEntity!.hasComponent("door")) {
      wallX += worldMap.getDoorOffset(mapX, mapY);
    }

    // Swap texture out for door frame
    if (rayTex == 4) {
      gameEntity = GameEntityRegistry.instance.getSingleton("doorFrame");
    }

    renderWall(
        gameEntity, wallX, side, rayDirX, rayDirY, drawStart, lineHeight, x);
    renderShadows(perpWallDist, x, drawStart, lineHeight);
  }

  void renderWall(GameEntity gameEntity, num wallX, int side, num rayDirX,
      num rayDirY, double drawStart, int lineHeight, int x) {
    SpriteComponent sprite;
    Sprite wallTexture;

    if (gameEntity.hasComponent("sprite")) {
      sprite = gameEntity.getComponent("sprite") as SpriteComponent;
      wallTexture = sprite.sprite;
    } else if (gameEntity.hasComponent("animatedSprite")) {
      AnimatedSpriteComponent animatedSprite =
          gameEntity.getComponent("animatedSprite") as AnimatedSpriteComponent;
      wallTexture = animatedSprite.currentSprite();
    } else {
      // throw new Error("No gameEntity found");
      return;
    }

    int texX = (wallX * wallTexture.image.width!).floor();
    if (side == 0 && rayDirX > 0) {
      texX = wallTexture.image.width! - texX - 1;
    } else if (side == 1 && rayDirY < 0) {
      texX = wallTexture.image.width! - texX - 1;
    }

    Renderer.renderClippedImage(wallTexture.image, texX, 0, 1,
        wallTexture.image.height!, x, drawStart, 1, lineHeight);
  }

  void renderShadows(num perpWallDist, int x, num drawStart, int lineHeight) {
    num lightRange = worldMap.worldDefinition.lightRange;
    double calculatedAlpha = math.max((perpWallDist + 0.002) / lightRange, 0);

    Renderer.rect(x.toInt(), drawStart.toInt(), 1, lineHeight + 1,
        Color(0, 0, 0, calculatedAlpha));
  }

  double calculatePerpWall(
      int side,
      int mapX,
      int mapY,
      Camera camera,
      num wallXOffset,
      num wallYOffset,
      int stepX,
      int stepY,
      num rayDirX,
      num rayDirY) {
    double perpWallDist = 0;

    if (side == 0) {
      perpWallDist =
          (mapX - camera.xPos + wallXOffset + (1 - stepX) / 2) / rayDirX;
    } else if (side == 1) {
      perpWallDist =
          (mapY - camera.yPos + wallYOffset + (1 - stepY) / 2) / rayDirY;
    }

    return perpWallDist;
  }



  void drawSpritesAndTransparentWalls(Camera camera) {
    List<num> spriteDistance = [];
    List<int> order = [];
    List<GameEntity> gameEntities = [];
    gameEntities.addAll(worldMap.worldDefinition.items);
    gameEntities.addAll(worldMap.worldDefinition.npcs);

    List<AnimatedSpriteComponent> sprites = [];

    for (int i = 0; i < gameEntities.length; i++) {
      order.add(i);

      GameEntity gameEntity = gameEntities[i];

      AnimatedSpriteComponent animatedSprite =
          gameEntity.getComponent("animatedSprite") as AnimatedSpriteComponent;

      PositionComponent position =
          gameEntity.getComponent("position") as PositionComponent;
      spriteDistance.add(
          (camera.xPos - position.x) * (camera.xPos - position.x) +
              (camera.yPos - position.y) * (camera.yPos - position.y));

      DistanceComponent distance =
          gameEntity.getComponent("distance") as DistanceComponent;
      distance.distance = spriteDistance[i];

      animatedSprite.x = position.x;
      animatedSprite.y = position.y;

      sprites.add(animatedSprite);
    }

    combSort(order, spriteDistance);

    int tp = _transparentWalls.isNotEmpty ? _transparentWalls.length - 1 : -1;

    for (int i = 0; i < sprites.length; i++) {
      num spriteX = sprites[order[i]].x - camera.xPos;
      num spriteY = sprites[order[i]].y - camera.yPos;

      double invDet =
          1.0 / (camera.xPlane * camera.yDir - camera.xDir * camera.yPlane);
      double transformX =
          invDet * (camera.yDir * spriteX - camera.xDir * spriteY);
      double transformY =
          invDet * (-camera.yPlane * spriteX + camera.xPlane * spriteY);

      if (transformY > 0) {
        while (tp >= 0) {
          num tpDist = ((camera.xPos - _transparentWalls[tp].xMap) *
                  (camera.xPos - _transparentWalls[tp].xMap)) +
              ((camera.yPos - _transparentWalls[tp].yMap) *
                  (camera.yPos - _transparentWalls[tp].yMap));
          if (spriteDistance[i] < tpDist) {
            _transparentWalls[tp].draw();
          } else {
            break;
          }
          tp--;
        }

        int spriteHeight =
            (Renderer.getCanvasHeight() / transformY).abs().round();
        double drawStartY = -spriteHeight / 2 + Renderer.getCanvasHeight() / 2;

        double spriteScreenX =
            (Renderer.getCanvasWidth() / 2) * (1 + transformX / transformY);
        int spriteWidth =
            (Renderer.getCanvasHeight() / transformY).abs().round();
        int drawStartX = (-spriteWidth / 2 + spriteScreenX).floor();
        int drawEndX = drawStartX + spriteWidth;

        int clipStartX = drawStartX;
        int clipEndX = drawEndX;

        if (drawStartX < -spriteWidth) {
          drawStartX = -spriteWidth;
        }

        if (drawEndX > Renderer.getCanvasWidth() + spriteWidth) {
          drawEndX = Renderer.getCanvasWidth() + spriteWidth;
        }

        for (int stripe = drawStartX; stripe <= drawEndX; stripe++) {
          if (stripe >= 0 && stripe < _zBuffer.length) {
            if (transformY > _zBuffer[stripe]) {
              if (stripe - clipStartX <= 1) {
                clipStartX = stripe;
              } else {
                clipEndX = stripe;
                break;
              }
            }
          }
        }

        num angle = math.atan2(spriteY, spriteY);
        sprites[order[i]].updateSpriteRotation(angle);

        double scaleDelta =
            sprites[order[i]].currentSprite().image.width! / spriteWidth;
        int drawXStart = ((clipStartX - drawStartX) * scaleDelta).floor();
        if (drawXStart < 0) {
          drawXStart = 0;
        }
        int drawXEnd = ((clipEndX - clipStartX) * scaleDelta).floor() + 1;
        if (drawXEnd > sprites[order[i]].currentSprite().image.width!) {
          drawXEnd = sprites[order[i]].currentSprite().image.width!;
        }

        int drawWidth = clipEndX - clipStartX;
        if (drawWidth < 0) {
          drawWidth = 0;
        }

        Renderer.renderClippedImage(
            sprites[order[i]].currentSprite().image,
            drawXStart,
            0,
            drawXEnd,
            sprites[order[i]].currentSprite().image.height!,
            clipStartX,
            drawStartY,
            drawWidth,
            spriteHeight);
      }
    }

    while (tp >= 0) {
      _transparentWalls[tp].draw();
      tp--;
    }
    _transparentWalls.clear();
  }

  void drawSkyBox(Color groundColor, Color skyColor) {
    // Sky
    final skyBox = worldMap.worldDefinition.skyBox;

    if (skyBox != null) {
      Renderer.renderImage(skyBox.image, 0, 0, Renderer.getCanvasWidth(),
          Renderer.getCanvasHeight());
    } else {
      // Sky
      Renderer.rect(0, 0, Renderer.getCanvasWidth(),
          Renderer.getCanvasHeight() / 2, worldMap.worldDefinition.skyColor);

      GameEntity player = _gameEntityRegistry.getSingleton("player");
      CameraComponent cameraComponent =
          player.getComponent("camera") as CameraComponent;

      int circleX = 250;
      int circleY = 50;

      double angleToNorth =
          math.atan2(cameraComponent.camera.yDir, cameraComponent.camera.xDir);

      double adjustedX = circleX - (cameraComponent.camera.xPos * 0.5);
      double adjustedY =
          circleY - (cameraComponent.camera.yPos * 0.5) + sin(angleToNorth) * 2;

      Renderer.circle(adjustedX, adjustedY, 15, Color(200, 200, 200));
      Renderer.circle(adjustedX, adjustedY, 20, Color(255, 255, 255, 0.015));
    }

    // Ground

    /*
    Renderer.rect(0, Renderer.getCanvasHeight() / 2, Renderer.getCanvasWidth(),
        Renderer.getCanvasHeight(), worldMap.worldDefinition.floorColor);


     */

    Renderer.rectGradient(
      0,
      Renderer.getCanvasHeight() / 2,
      Renderer.getCanvasWidth(),
      Renderer.getCanvasHeight(),
      worldMap.worldDefinition.skyColor.toString(),
      worldMap.worldDefinition.floorColor.toString(),
    );
  }

  void combSort(List<int> order, List<num> dist) {
    int amount = order.length;
    int gap = amount;
    bool swapped = false;

    while (gap > 1 || swapped) {
      gap = (gap * 10) ~/ 13;
      if (gap == 9 || gap == 10) {
        gap = 11;
      }
      if (gap < 1) {
        gap = 1;
      }
      swapped = false;
      for (int i = 0; i < amount - gap; i++) {
        int j = i + gap;

        if (dist[i] < dist[j]) {
          var tempDist = dist[i];
          dist[i] = dist[j];
          dist[j] = tempDist;

          var tempOrder = order[i];
          order[i] = order[j];
          order[j] = tempOrder;

          swapped = true;
        }
      }
    }
  }

  void flushBuffer() {}
}
