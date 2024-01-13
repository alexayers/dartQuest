import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class DustRenderSystem implements GameRenderSystem {
  List<Particle> _particles = [];

  DustRenderSystem() {
    for (int i = 0; i < 800; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(5, 7);
    particle.height = MathUtils.getRandomBetween(5, 7);
    particle.color =
        Color(120, 120, 120, MathUtils.getRandomBetween(1, 100) / 1000);
    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.velY = (MathUtils.getRandomBetween(1, 7) / 100) * -1;
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  @override
  void process() {
    for (var particle in _particles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

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
