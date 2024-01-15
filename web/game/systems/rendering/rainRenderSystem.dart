import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class RainRenderSystem implements GameRenderSystem {
  final List<Particle> _particles = [];

  RainRenderSystem() {
    for (int i = 0; i < 100; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(3, 10);
    particle.height = MathUtils.getRandomBetween(16, 64);

    if (particle.color.alpha < 0) {
      particle.color.alpha = MathUtils.getRandomBetween(1, 100) / 1000;
    } else {
      particle.color =
          Color(255, 255, 255, MathUtils.getRandomBetween(1, 100) / 1000);
    }

    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = 0;
    particle.velY = MathUtils.getRandomBetween(500, 1000);
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  @override
  void process() {
    for (var particle in _particles) {
      Renderer.rect(particle.x, particle.y, particle.width,particle.height, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;
      particle.color.alpha -= 0.005;
      particle.lifeSpan -= 0.004;

      if (particle.lifeSpan < 0 || particle.color.alpha <= 0) {
        refreshParticle(particle);
      }
    }
  }
}
