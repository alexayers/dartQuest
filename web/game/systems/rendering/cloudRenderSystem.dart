import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class CloudRenderSystem implements GameRenderSystem {
  final List<Particle> _particles = [];

  CloudRenderSystem() {
    for (int i = 0; i < 5000; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(-200, 500) * -1;
    particle.y = MathUtils.getRandomBetween(20, 120);
    particle.width = MathUtils.getRandomBetween(5, 20);
    particle.height = MathUtils.getRandomBetween(5, 20);

    if (particle.color.alpha < 0) {
      particle.color.alpha = 0.050;
    } else {
      particle.color =
          Color(200, 200, 200, 0.050);
    }

    particle.lifeSpan = 1000;
    particle.velX = 0.25;
    particle.velY = 0;
    particle.decayRate = 0.001;

    return particle;
  }

  @override
  void process() {
    for (var particle in _particles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;
      particle.lifeSpan -= 0.004;

      if (particle.lifeSpan < 0) {
        refreshParticle(particle);
      }
    }
  }
}
