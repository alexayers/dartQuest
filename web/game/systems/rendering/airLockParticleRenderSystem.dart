import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class AirLockParticleRenderSystem implements GameRenderSystem {
  final List<Particle> _particles = [];

  AirLockParticleRenderSystem() {
    for (int i = 0; i < 200; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(50, 90);
    particle.height = MathUtils.getRandomBetween(50, 90);
    particle.color =
        Color(170, 170, 170, MathUtils.getRandomBetween(1, 100) / 1000);
    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.velY = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  void process() {
    for (var particle in _particles) {
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
    }
  }
}
