import 'dart:html';

import '../../engine/application/gameScreen.dart';
import '../../engine/audio/audioManager.dart';
import '../../engine/gameEvent/gameEventBus.dart';
import '../../engine/gameEvent/screenChangeEvent.dart';
import '../../engine/input/keyboard.dart';
import '../../engine/input/mouse.dart';
import '../../engine/primitives/color.dart';
import '../../engine/rendering/font.dart';
import '../../engine/rendering/particle.dart';
import '../../engine/rendering/renderer.dart';
import '../../engine/utils/mathUtils.dart';
import '../../fonts.dart';
import 'screens.dart';

class PressEnterScreen implements GameScreen {

  final ImageElement _logo = ImageElement();
  final List<Particle> _fireParticles = [];
  final List<Particle> _smokeParticles = [];
  AudioManager _audioManager = AudioManager.instance;

  @override
  void init() {
    _logo.src = "../../assets/images/titleScreen.png";

    for (int i = 0; i < 800; i++) {
      _fireParticles.add(refreshFireParticle(Particle()));
    }

    for (int i = 0; i < 500; i++) {
      _smokeParticles.add(refreshSmokeParticle(Particle()));
    }
    _audioManager.register("startGame", "../../assets/sound/startGame.ogg");

  }

  Particle refreshFireParticle(Particle particle) {

    List<Color> colors = [];
    colors.add(Color(231, 174, 17, MathUtils.getRandomBetween(1, 100) / 1000));
    colors.add(Color(200, 144, 17, MathUtils.getRandomBetween(1, 100) / 1000));

    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(50, 90);
    particle.height = MathUtils.getRandomBetween(50, 90);
    particle.color = MathUtils.getRandomArrayElement(colors);
        Color(231, 174, 17, MathUtils.getRandomBetween(1, 100) / 1000);
    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.velY = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  Particle refreshSmokeParticle(Particle particle) {

    List<Color> colors = [];
    colors.add(Color(190, 190, 190, MathUtils.getRandomBetween(1, 100) / 1000));
    colors.add(Color(57, 57, 57, MathUtils.getRandomBetween(1, 100) / 1000));


    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(50, 90);
    particle.height = MathUtils.getRandomBetween(50, 90);
    particle.color = MathUtils.getRandomArrayElement(colors);
    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.velY = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  @override
  void keyboard() {
    if (isKeyDown(keyboardInput.enter)) {
      GameEventBus.publish(ScreenChangeEvent(Screens.outside.name));
    }
  }

  @override
  void logicLoop() {
    keyboard();
  }

  @override
  void mouseClick(double x, double y, MouseButton mouseButton) {
    // TODO: implement mouseClick
  }

  @override
  void mouseMove(double x, double y) {
    // TODO: implement mouseMove
  }

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    _audioManager.play("startGame");
  }

  @override
  void renderLoop() {

    renderSmoke();
    renderFire();

    Renderer.renderImage(_logo, 25, 0, 800, 800);

    Renderer.print(
        "Press [enter] to begin", 350, 550, Font(Fonts.oxanium.name, 20, Colors.white));
  }


  void renderSmoke() {
    for (var particle in _smokeParticles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;

      if (particle.width > 0) {
        particle.width -= 0.65;

        if (particle.width < 0) {
          particle.width = 0;
        }
      }

      if (particle.height > 0) {
        particle.height -= 0.65;

        if (particle.height < 0) {
          particle.height = 0;
        }
      }

      particle.color.alpha -= 0.005;
      particle.lifeSpan -= 0.004;

      if (particle.lifeSpan <= 1 ){
        refreshSmokeParticle(particle);
      }
    }
  }

  void renderFire() {
    for (var particle in _fireParticles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;

      if (particle.width > 0) {
        particle.width -= 0.65;

        if (particle.width < 1) {
          particle.width = 0;
        }
      }

      if (particle.height > 0) {
        particle.height -= 0.65;

        if (particle.height < 0) {
          particle.height = 0;
        }
      }

      particle.color.alpha -= 0.005;
      particle.lifeSpan -= 0.004;

      if (particle.lifeSpan <=0 ){
        refreshFireParticle(particle);
      }
    }
  }
}
